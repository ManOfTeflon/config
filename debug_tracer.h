#pragma once
#include <sstream>
#include <string>
#include <typeinfo>
#include <execinfo.h>
#include <cxxabi.h>
#include <assert.h>
#include "tracing.h"

// #define MEMSQL_SPECIFIC

#ifdef MEMSQL_SPECIFIC
#include "MemSqlUtil.h"
#endif

// #define trace_none
// #define trace_no_context
// #define trace_no_info

inline const char* debug_basename(const char* file)
{
    int64_t len = strlen(file);
    for (; len >= 0 && file[len] != '/'; --len);
    return file + len + 1;
}

struct debug_buffer
{
    template <typename T>
    debug_buffer(const T& t);
    debug_buffer(const char* data, size_t len, bool trunc = false) : data(reinterpret_cast<const uint8_t*>(data)), len(len), trunc(trunc) { }
    debug_buffer(const void* data, size_t len, bool trunc = false) : data(reinterpret_cast<const uint8_t*>(data)), len(len), trunc(trunc) { }
    debug_buffer(const uint8_t* data, size_t len, bool trunc = false) : data(data), len(len), trunc(trunc) { }
    const uint8_t* data;
    size_t len;
    bool trunc;
    static size_t trunc_len() { return 8; }
};


template <typename T>
debug_buffer::debug_buffer(const T& t) :
    data(reinterpret_cast<const uint8_t*>(&t)),
    len(std::min<size_t>(sizeof(T), trunc_len())),
    trunc(sizeof(T) > trunc_len())
{ }

template <>
inline debug_buffer::debug_buffer(const char* const& data) :
    data(reinterpret_cast<const uint8_t*>(data)), len(trunc_len()), trunc(true) { }

template <>
inline debug_buffer::debug_buffer(char* const& data) :
    data(reinterpret_cast<const uint8_t*>(data)), len(trunc_len()), trunc(true) { }

template <>
inline debug_buffer::debug_buffer(const void* const& data) :
    data(reinterpret_cast<const uint8_t*>(data)), len(trunc_len()), trunc(true) { }

template <>
inline debug_buffer::debug_buffer(void* const& data) :
    data(reinterpret_cast<const uint8_t*>(data)), len(trunc_len()), trunc(true) { }

template <>
inline debug_buffer::debug_buffer(const uint8_t* const& data) :
    data(data), len(trunc_len()), trunc(true) { }

template <>
inline debug_buffer::debug_buffer(uint8_t* const& data) :
    data(data), len(trunc_len()), trunc(true) { }

inline std::string __debug_hex(const debug_buffer& buf, bool convert = true)
{
    if (!buf.data)
    {
        return std::string("(nullptr)");
    }
    std::stringstream ss;
    for (size_t i = 0; i < buf.len; ++i)
    {
        ss << std::hex << (int)((buf.data[i] >> 4) & 0xf);
        ss << std::hex << (int)(buf.data[i] & 0xf);
    }
    ss << std::dec;
    if (buf.trunc)
    {
        ss << "...";
    }
    else if ((true || convert) && buf.len < sizeof(uint64_t))
    {

        ss << "=" << (*reinterpret_cast<const uint64_t*>(buf.data) & (((uint64_t)1 << (buf.len * 8)) - 1));
    }
    return ss.str();
}

template <typename T>
struct debug_contents__;

template <>
struct debug_contents__<void> : public std::string
{
    debug_contents__() : std::string("void") { }
};

template <typename T>
struct debug_contents__ : public debug_contents__<void>
{
    debug_contents__(const T& t)
    {
        std::stringstream ss;
        const char* func_stripped = __PRETTY_FUNCTION__ +
            strlen("debug_contents__<T>::debug_contents__(const T&) [with T = ");
        std::string type(func_stripped, strlen(func_stripped) - 1);
        char buf[20];
        snprintf(buf, sizeof(buf), "%p", &t);
        ss << type << " @ " << buf << "(" << __debug_hex(debug_buffer(t)) << ")";
        assign(ss.str());
    }
};

template <>
struct debug_contents__<debug_buffer> : public debug_contents__<void>
{
    debug_contents__(const debug_buffer& t)
    {
        assign("'" + __debug_hex(t, false) + "'");
    }
};

#define INTEGRAL_TRACER(T, f) \
template <> \
struct debug_contents__<T> : public debug_contents__<void> \
{ \
    debug_contents__(T t) \
    { \
        char buf[1024]; \
        snprintf(buf, sizeof(buf), "0x%lx=%" #f #f, (size_t)t, t); \
        assign(buf); \
    } \
};
INTEGRAL_TRACER(char, c)
INTEGRAL_TRACER(uint8_t, hhu)
INTEGRAL_TRACER(int8_t, hhd)
INTEGRAL_TRACER(uint16_t, hu)
INTEGRAL_TRACER(int16_t, hd)
INTEGRAL_TRACER(uint32_t, u)
INTEGRAL_TRACER(int32_t, d)
INTEGRAL_TRACER(uint64_t, lu)
INTEGRAL_TRACER(int64_t, ld)
INTEGRAL_TRACER(unsigned long long, llu)
INTEGRAL_TRACER(signed long long, lld)
INTEGRAL_TRACER(uint8_t*, p)
#undef INTEGRAL_TRACER

template <>
struct debug_contents__<bool> : public debug_contents__<void>
{
    debug_contents__(bool t)
    {
        assign(t ? "true" : "false");
    }
};

template <>
struct debug_contents__<void*> : public debug_contents__<void>
{
    debug_contents__(void* t)
    {
        char buf[20];
        snprintf(buf, sizeof(buf), "&%p", t);
        assign(buf);
    }
};

template <typename T>
struct debug_contents__<T*> : public debug_contents__<T>
{
    debug_contents__(T* t) : debug_contents__<typename std::remove_cv<T>::type>(*t)
    {
        assign("&" + *this);
    }
};

template <typename T>
struct debug_contents__<const T*> : public debug_contents__<T*>
{
    debug_contents__(const T* t) : debug_contents__<typename std::remove_cv<T>::type*>(const_cast<typename std::remove_cv<T>::type*>(t)) { }
};

template <>
struct debug_contents__<char*> : public debug_contents__<void>
{
    debug_contents__(char* t)
    {
        if (t)
        {
            assign("'" + std::string(t) + "'");
        }
        else
        {
            assign("nullptr");
        }
    }
};

#define debug_contents_t(T, t) \
    debug_contents__<typename std::remove_cv<T>::type>(t).c_str()

#define debug_contents(t) \
    debug_contents_t(typename std::remove_reference<decltype(t)>::type, t)

#define debug_void debug_contents_t(void,)

template <typename ... Args>
struct debug_contentss__;

template <typename Arg0, typename ... Args>
struct debug_contentss__<Arg0, Args...> : public debug_contentss__<Args...> {
    debug_contentss__(Arg0&& arg0, Args&& ... args) : debug_contentss__<Args...>(std::forward<Args>(args)...) {
        assign(debug_contents__<typename std::remove_cv<typename std::remove_reference<Arg0>::type>::type>(std::forward<Arg0>(arg0)) + ", " + *this);
    }
};

template <>
struct debug_contentss__<> : public std::string {
    debug_contentss__() : std::string("") {
    }
};

template <typename Arg>
struct debug_contentss__<Arg> : public debug_contentss__<> {
    debug_contentss__(Arg&& arg) : debug_contentss__<>() {
        assign(debug_contents__<typename std::remove_cv<typename std::remove_reference<Arg>::type>::type>(std::forward<Arg>(arg)));
    }
};

template <typename ... Args>
std::string debug_contentss(Args&& ... args) {
    return debug_contentss__<Args...>(std::forward<Args>(args)...);
}

#ifdef trace_none
#undef trace_none
static bool trace_none = false;
#define trace_none
#else
static bool trace_none = false;
#endif

#define trace_show trace_show__(trace_none)

inline bool trace_show__() { return false; }
inline bool trace_show__(bool no_trace) { return !no_trace; }

#define trace_do(...) \
    do { if (trace_show) { __VA_ARGS__; } } while (0)

template <typename ... Args>
inline bool trace_print(const char* fmt, Args&& ... args) {
    trace_do(
#ifndef trace_no_info
        TRACE_INFO(fmt, std::forward<Args>(args)...);
#else
        fprintf(stderr, fmt, std::forward<Args>(args)...);
        fprintf(stderr, "\n");
#endif
    );
    return true;
}

#define trace_stack(...) \
    do { \
        std::string id = debug_contentss(__VA_ARGS__); \
        trace_context("Callstack (%s):", id.c_str()); \
        trace_stack__(id.c_str()); \
    } while (0);

inline void trace_stack__(const char* id) {
    void* addrlist[64];

    int addrlen = backtrace(addrlist, sizeof(addrlist) / sizeof(void*));

    if (addrlen == 0) {
	trace_print("%s: <empty, possibly corrupt>\n", id);
	return;
    }

    char** symbollist = backtrace_symbols(addrlist, addrlen);
    assert(symbollist);

    size_t funcnamesize = 256;
    char* funcname = (char*)malloc(funcnamesize + 2);

    for (int i = 1; i < addrlen; i++)
    {
	char *begin_name = 0, *begin_offset = 0, *end_offset = 0;

	for (char *p = symbollist[i]; *p; ++p)
	{
	    if (*p == '(')
		begin_name = p;
	    else if (*p == '+')
		begin_offset = p;
	    else if (*p == ')' && begin_offset) {
		end_offset = p;
		break;
	    }
	}

	if (begin_name && begin_offset && end_offset
	    && begin_name < begin_offset)
	{
	    *begin_name++ = '\0';
	    *begin_offset++ = '\0';
	    *end_offset = '\0';

	    int status;
	    char* ret = abi::__cxa_demangle(begin_name,
					    funcname, &funcnamesize, &status);
	    if (status == 0) {
		funcname = ret;
		trace_print("%s:  %s : %s+%s", id,
			debug_basename(symbollist[i]), funcname, begin_offset);
	    }
	    else {
		trace_print("%s:  %s : %s()+%s", id,
			debug_basename(symbollist[i]), begin_name, begin_offset);
	    }
	}
	else
	{
	    // couldn't parse the line? print the whole line.
	    trace_print("%s:  %s", id, symbollist[i]);
	}
    }

    free(funcname);
    free(symbollist);
}

static __thread size_t traced_scopes = 0;
static __thread const char* traced_inner_func = nullptr;

#define trace_in_scope(fmt, ...) \
    (!traced_inner_func || strcmp(traced_inner_func, __PRETTY_FUNCTION__) || trace_context(fmt, ##__VA_ARGS__))

#define traced_loc_fmt                      "%s @ %s:%d"
#define traced_loc_args__(func, file, line) func, debug_basename(file), line
#define traced_loc_args_(...)               traced_loc_args__(__VA_ARGS__)
#define traced_loc_args                     traced_loc_args_(func_file_line)

#ifndef trace_no_context
#define trace_context(fmt, ...) \
    trace_print(traced_loc_fmt "> " fmt, traced_loc_args, ##__VA_ARGS__)
#else
#define trace_context(fmt, ...) \
    trace_print(fmt, ##__VA_ARGS__)
#endif

#define trace_return        return Returner(__func__, __FILE__, __LINE__) ,
#define trace_void_return   return Returner(__func__, __FILE__, __LINE__).ReturnVoid()
#define trace_return_lite   switch (trace_in_scope("Returning")) default: return
#define trace_goto          if (trace_in_scope("Going somewhere")) goto
#define trace_continue      if (trace_in_scope("Continuing")) continue
#define trace_break         if (trace_in_scope("Breaking")) break

#define func_file_line func, file, line
struct Returner {
    Returner(const char* func, const char* file, int line)
        : func(func), file(file), line(line) { }
    template <typename T>
    T operator , (T&& r) {
        trace_context("returning %s", debug_contents(r));
        return std::forward<T>(r);
    }
    void ReturnVoid(void) {
        trace_context("returning %s", debug_void);
    }
    const char* func;
    const char* file;
    int         line;
};

#ifndef trace_no_info
struct TraceScopeBase {
    TraceScopeBase(const char* new_inner_func, const char* func, const char* file, int line)
        : inner_func(traced_inner_func) {
        traced_inner_func = new_inner_func;
        ++traced_scopes;
        trace_print("--> " traced_loc_fmt, traced_loc_args);
    }
    ~TraceScopeBase() {
        trace_print("<--");
        --traced_scopes;
        traced_inner_func = inner_func;
    }
    const char* inner_func;
};
struct TraceScope : TraceScopeBase {
    template <typename ... Args>
    TraceScope(Args&& ... args)
        : TraceScopeBase(std::forward<Args>(args)...), context("  ")
    { }
    AutoTraceContext context;
};
#else
struct TraceScope {
    TraceScope(const char* new_inner_func, const char* func, const char* file, int line)
        : inner_func(traced_inner_func), func(func), file(file), line(line) {
        traced_inner_func = new_inner_func;
        ++traced_scopes;
        trace_print("vvv " traced_loc_fmt, traced_loc_args);
    }
    ~TraceScope() {
        trace_print("^^^ " traced_loc_fmt, traced_loc_args);
        --traced_scopes;
        traced_inner_func = inner_func;
    }
    const char* inner_func;
    const char* func;
    const char* file;
    int         line;
};
#endif

#ifdef MEMSQL_SPECIFIC
inline ThreadId MakeTid() {
    ThreadId tid;
    SetupThreadLocals(tid, true);
    return tid;
}
struct BackgroundThreadTracer {
    BackgroundThreadTracer(ThreadId threadId) : context("t%d c- ", threadId) { }
    AutoTraceContext context;
};
struct BackgroundThread {
    BackgroundThread() : tid(MakeTid()), tracer(tid) { }
    ~BackgroundThread() { DestroyThreadLocals(true); }
    ThreadId               tid;
    BackgroundThreadTracer tracer;
};
#define AutoBackgroundThread() AutoVar(BackgroundThread, );
#define AutoBackgroundThreadTracer(tid) AutoVar(BackgroundThreadTracer, (tid));

#define trace_refs \
    void AddRef(Ref DEBUG_ONLY(ref)) \
    { \
        trace_stack(ref); \
        RefCounted::AddRef(DEBUG_ONLY(ref)); \
    } \
    \
    uint32_t RemoveRef(Ref DEBUG_ONLY(ref)) \
    { \
        trace_stack(ref); \
        return RefCounted::RemoveRef(DEBUG_ONLY(ref)); \
    }

#endif

#define trace_scope \
    AutoVar(TraceScope, (__PRETTY_FUNCTION__, func_file_line))

#undef func_file_line

#define func_file_line      __func__, __FILE__, __LINE__

#define trace_point         trace_context("checkpoint")

#define trace_expr(n, x)    trace_context(n "=%s", debug_contents(x))

#define trace_var(x)        trace_expr(#x, (x))

#define trace_errno() \
    do { \
        auto tmp = errno; \
        trace_context("Error (%d): %s", tmp, strerror(tmp)); \
        errno = tmp; \
    } while (0)

#define trace_vars(...)     trace_context("(" #__VA_ARGS__  ")=(%s)", debug_contentss(__VA_ARGS__).c_str())

#define trace_pause()       raise(SIGINT)

// #define return              trace_return_lite
// #define goto                trace_goto
// #define continue            trace_continue
// #define break               trace_break
