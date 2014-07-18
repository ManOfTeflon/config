function _get_options () {
    local key="$2"
    declare -A params=( "${!1}" )
    declare -a aliases=( "$key" )

    local alias
    while :; do
        [ ${params[$key]+exists} ] || break
        declare -A options="${params[$key]}"

        alias="${options[alias]}"
        [ ${options[alias]+exists} ] || break
        aliases+=( "$alias" )
        local key="$alias"
    done

    if [ ${params[$key]+exists} ]; then
        echo "${params[$key]}"
        return 0
    fi

    local message="Unknown argument "

    for alias in "${aliases[@]}"; do
        local message="$message -> $alias"
    done

    usage params[@] "$message"
    return 1
}

function _get_option () {
    _=
    declare -A options=("${!1}")
    local dest="$(echo "$2" | sed -e "s/^--\?//" -e "s/-/_/g" )"
    local option="$3"
    local defaults=(
        [action]="store"
        [nargs]="1"
        [dest]="$dest"
    )
    [ ${options[$option]+exists} ] && _="${options[$option]}" || _="${defaults[$option]}"
    return 0
}

function _fatal_error () {
    echo "FATAL ERROR:" "$@"
    exit 2
}

function _keep_going () {
    local found="$1"
    local nargs="$2"
    [ "$nargs" == "*" -o "$nargs" == "+" ] && return 0
    if (( found < nargs )); then return 0; fi
    return 1
}

function _repr () {
    case "$1" in
        array)
            declare -A values=("${!2}")
            local out=""
            for value in "${values[@]}"; do
                local out="$out [$(repr string $value)]=$(repr string ${values[$value]})"
            done
            echo "( $out )" ;;
        string)
            echo "'$(echo "$2" | sed "s/'/'\"'\"'/g")'" ;;
        *)
            _fatal_error "_repr does not understand $1" ;;
    esac
}

function _verify () {
    for ((i=0; i < "${#params[@]}"; i++)); do
        param="${params[$i]}"
        local name="${param%%=*}"
        declare -A options="${param#*=}"

        local default=
        local dest="$(echo "$2" | sed -e "s/^--\?//" -e "s/-/_/g" )"
        for opt in "${options[@]}"; do
            local option="${opt%%=*}"
            local value="${opt#*=}"
            case "$option" in
                action)
                    case "$value" in
                        store) ;;
                        store_true)
                            [ -z "$default" -a "${default:=0}" ] || _fatal_error "Cannot specify 'default' and boolean storage for argument $name" ;;
                        store_false)
                            [ -z "$default" -a "${default:=1}" ] || _fatal_error "Cannot specify 'default' and boolean storage for argument $name" ;;
                        *) _fatal_error "Unknown action $value for argument $name" ;;
                    esac ;;
                nargs)
                    [[ "$value" =~ [+*]|[1-9][0-9]* ]] || _fatal_error "Illegal value of nargs for argument $name" ;;
                alias) ;;
                dest)
                    dest="$value" ;;
                default)
                    [ -z "$default" -a "${default:=$value}" ] || _fatal_error "Cannot specify 'default' and boolean storage for argument $name" ;;
                short)
                     [ "${#value}" == "1" ] || _fatal_error "Short name must be exactly one character" ;;
                *) _fatal_error "Unknown option $option for argument $name" ;;
            esac
        done
        out[$dest]=$default
    done
}

usage () {
    declare -A params=("${!1}")
    echo "Usage" 1>&2
    echo "$2" 1>&2
    return 0
}

parse_args () {
    echo "${!1}"
    declare -A params="${!1}"
    declare -A out
    _verify params
    shift
    declare -A options="$(_get_options params[@] "$key")"
    local nargs
    while (( $# )); do
        declare -i single_val=0
        if [[ "$1" =~ (--[^=]+)=(.*) ]]; then
            local key="${BASH_REMATCH[1]}"
            options="$(_get_options params[@] "$key")"
            if (( $? )); then usage params[@] "No such argument: '$key'"; return 1; fi

            single_val=1
            local value="${BASH_REMATCH[2]}"
        elif [[ "$1" =~ (--[^=]+) ]]; then
            local key="${BASH_REMATCH[1]}"
            options="$(_get_options params[@] "$key")"
            if (( $? )); then usage params[@] "No such argument: '$key'"; return 1; fi
        elif [[ "$1" =~ (-[^=])(.*) ]]; then
            local key="${BASH_REMATCH[1]}"
            options="$(_get_options params[@] "$key")"
            if (( $? )); then usage params[@] "No such argument: '$key'"; return 1; fi

            if [ "${#BASH_REMATCH}" != "1" ]; then
                single_val=1
                local value="${BASH_REMATCH[2]}"
            fi
        else
            usage params[@] "Unexpected token '$1'"; return 1
        fi

        local action="$(_get_option options[@] "$key" action)"
        local dest="$(_get_option options[@] "$key" dest)"
        if (( single_val )); then
            if [ "$action" != "store" ]; then
                usage params[@] "No value allowed for argument '$key'"; return 1
            fi
            out[$dest]="$(_repr string "$value")"
        else
            if [ ${out[$key]+exists} ]; then
                usage params[@] "Duplicate argument $key"; return 1
            fi

            case "$action" in
                store)
                    nargs="$(_get_option options[@] "$key" nargs)"
                    declare -i found=0
                    declare -a values=( )
                    local next_command=0
                    shift
                    while (( "$#" )) && ( _keep_going "$found" "$nargs" ); do
                        if [ ${params[$1]+exists} ]; then
                            local next_command=1
                            break
                        fi
                        let found=found+1
                        values+=( "$1" )
                        shift
                    done
                    if (( "$next_command" )); then
                        if [ "$nargs" != "*" -a "$nargs" != "+" -a "$nargs" != "$found" ]; then
                            usage params[@] "Expected $nargs arguments for $key (found $found)"; return 1
                        fi
                    fi
                    if [ "$nargs" == "1" ]; then
                        out[$dest]="'$(_repr string "${values[0]}")'"
                    else
                        out[$dest]="$(_repr array "${value[@]}")"
                    fi
                    continue
                    ;;
                store_true)
                    out[$dest]=1
                    ;;
                store_false)
                    out[$dest]=0
                    ;;
            esac
        fi

        shift
    done

    echo "${out[@]}"

    return 0
}

args=(
    ['--foo']='()'
    ['--bar']='(
        [action]=store_true
    )'
    ['--baz']='(
        [default]="( 1 2 3 )"
    )'
    ['-b']='(
        [alias]="--bar"
    )'
)

parse_args args[@] || exit $?

echo "'$bar'"
echo "'$foo'"
echo "${baz[@]}"

