/* Warning: Do not edit this file.
   Auto-generated by 'make_compiler_flags'.*/
const char* erts_build_flags_CFLAGS = "-Werror=return-type  -g -O2 -I/Users/david/Documents/workspace/my_otp/erts/x86_64-apple-darwin15.6.0   -D_XOPEN_SOURCE -DERTS_SMP -DHAVE_CONFIG_H -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement -DUSE_THREADS -D_THREAD_SAFE -D_REENTRANT -DPOSIX_THREADS  ";
const char* erts_build_flags_CONFIG_H = "/* x86_64-apple-darwin15.6.0/config.h.  Generated by configure.  */\n\
/* config.h.in.  Generated from configure.in by autoheader.  */\n\
\n\
\n\
#define GHBN_R_SOLARIS  2\n\
#define GHBN_R_AIX      3\n\
#define GHBN_R_GLIBC    4\n\
\n\
\n\
/* Assumed cache-line size (in bytes) */\n\
#define ASSUMED_CACHE_LINE_SIZE 64\n\
\n\
/* Define the brk() argument type. */\n\
#define BRK_ARG_TYPE const void *\n\
\n\
/* Define the brk() return type. */\n\
#define BRK_RET_TYPE void *\n\
\n\
/* Define if you do not have a high-res. timer & want to use times() instead\n\
   */\n\
/* #undef CORRECT_USING_TIMES */\n\
\n\
/* Modern style mcontext_t in MacOSX */\n\
#define DARWIN_MODERN_MCONTEXT \n\
\n\
/* Define if you need to include rpc/types.h to get INADDR_LOOPBACK defined */\n\
/* #undef DEF_INADDR_LOOPBACK_IN_RPC_TYPES_H */\n\
\n\
/* Define if you need to include winsock2.h to get INADDR_LOOPBACK defined */\n\
/* #undef DEF_INADDR_LOOPBACK_IN_WINSOCK2_H */\n\
\n\
/* Define if you want to disable child waiter thread */\n\
/* #undef DISABLE_CHILD_WAITER_THREAD */\n\
\n\
/* Define if you want to disable vfork. */\n\
/* #undef DISABLE_VFORK */\n\
\n\
/* Define to 1 if your processor stores the words in a double in middle-endian\n\
   format (like some ARMs). */\n\
/* #undef DOUBLE_MIDDLE_ENDIAN */\n\
\n\
/* Define if you want to enable child waiter thread */\n\
/* #undef ENABLE_CHILD_WAITER_THREAD */\n\
\n\
/* Dirty scheduler support */\n\
/* #undef ERL_DRV_DIRTY_SCHEDULER_SUPPORT */\n\
\n\
/* Dirty scheduler support */\n\
/* #undef ERL_NIF_DIRTY_SCHEDULER_SUPPORT */\n\
\n\
/* Define if sbrk()/brk() wrappers can track malloc()s core memory use */\n\
/* #undef ERTS_BRK_WRAPPERS_CAN_TRACK_MALLOC */\n\
\n\
/* Define to override the default number of write_concurrency locks */\n\
/* #undef ERTS_DB_HASH_LOCK_CNT */\n\
\n\
/* Define if the emulator supports dirty schedulers */\n\
/* #undef ERTS_DIRTY_SCHEDULERS */\n\
\n\
/* The only reason ERTS_EMU_CMDLINE_FLAGS exists is to force modification of\n\
   config.h when the emulator command line flags are modified by configure */\n\
#define ERTS_EMU_CMDLINE_FLAGS \" -g -O2 -I/Users/david/Documents/workspace/my_otp/erts/x86_64-apple-darwin15.6.0   -D_XOPEN_SOURCE -g  -D_XOPEN_SOURCE -I/Users/david/Documents/workspace/my_otp/erts/x86_64-apple-darwin15.6.0    -DUSE_THREADS -D_THREAD_SAFE -D_REENTRANT -DPOSIX_THREADS  -Werror=return-type  -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement\"\n\
\n\
/* Define if you have kernel poll and want to use it */\n\
#define ERTS_ENABLE_KERNEL_POLL 1\n\
\n\
/* Define if the smp emulator is built */\n\
#define ERTS_HAVE_SMP_EMU 1\n\
\n\
/* Define if dlopen() needs to be called before first call to dlerror() */\n\
/* #undef ERTS_NEED_DLOPEN_BEFORE_DLERROR */\n\
\n\
/* Define if poll() should be used instead of select() */\n\
/* #undef ERTS_USE_POLL */\n\
\n\
/* Define if __after_morecore_hook can track malloc()s core memory use. */\n\
/* #undef ERTS___AFTER_MORECORE_HOOK_CAN_TRACK_MALLOC */\n\
\n\
/* Define if bigendian */\n\
/* #undef ETHR_BIGENDIAN */\n\
\n\
/* Define if you get a register shortage with cmpxchg8b and position\n\
   independent code */\n\
/* #undef ETHR_CMPXCHG8B_REGISTER_SHORTAGE */\n\
\n\
/* Define if you want to disable native ethread implementations */\n\
/* #undef ETHR_DISABLE_NATIVE_IMPLS */\n\
\n\
/* Define if you want to force usage of pthread rwlocks */\n\
/* #undef ETHR_FORCE_PTHREAD_RWLOCK */\n\
\n\
/* Define if you use a gcc that supports the double word cmpxchg instruction\n\
   */\n\
/* #undef ETHR_GCC_HAVE_DW_CMPXCHG_ASM_SUPPORT */\n\
\n\
/* Define if you use a gcc that supports -msse2 and understand sse2 specific\n\
   asm statements */\n\
/* #undef ETHR_GCC_HAVE_SSE2_ASM_SUPPORT */\n\
\n\
/* Define if you have all ethread defines */\n\
#define ETHR_HAVE_ETHREAD_DEFINES 1\n\
\n\
/* Define if you have libatomic_ops atomic operations */\n\
/* #undef ETHR_HAVE_LIBATOMIC_OPS */\n\
\n\
/* Define if you have a linux futex implementation. */\n\
/* #undef ETHR_HAVE_LINUX_FUTEX */\n\
\n\
/* Define if the pthread.h header file is in pthread/mit directory. */\n\
/* #undef ETHR_HAVE_MIT_PTHREAD_H */\n\
\n\
/* Define if you have the pthread_attr_setguardsize function. */\n\
#define ETHR_HAVE_PTHREAD_ATTR_SETGUARDSIZE 1\n\
\n\
/* Define if you have the <pthread.h> header file. */\n\
#define ETHR_HAVE_PTHREAD_H 1\n\
\n\
/* Define if you have the pthread_rwlockattr_setkind_np() function. */\n\
/* #undef ETHR_HAVE_PTHREAD_RWLOCKATTR_SETKIND_NP */\n\
\n\
/* Define if you have the PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP rwlock\n\
   attribute. */\n\
/* #undef ETHR_HAVE_PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP */\n\
\n\
/* Define if you have the pthread_spin_lock function. */\n\
/* #undef ETHR_HAVE_PTHREAD_SPIN_LOCK */\n\
\n\
/* Define if you have the pthread_yield() function. */\n\
/* #undef ETHR_HAVE_PTHREAD_YIELD */\n\
\n\
/* Define if you have the <sched.h> header file. */\n\
#define ETHR_HAVE_SCHED_H 1\n\
\n\
/* Define if you have the sched_yield() function. */\n\
#define ETHR_HAVE_SCHED_YIELD 1\n\
\n\
/* Define if you have the <sys/time.h> header file. */\n\
#define ETHR_HAVE_SYS_TIME_H 1\n\
\n\
/* Define if you have _InterlockedAnd() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDAND */\n\
\n\
/* Define if you have _InterlockedAnd64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDAND64 */\n\
\n\
/* Define if you have _InterlockedCompareExchange() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE */\n\
\n\
/* Define if you have _InterlockedCompareExchange128() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE128 */\n\
\n\
/* Define if you have _InterlockedCompareExchange64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE64 */\n\
\n\
/* Define if you have _InterlockedCompareExchange64_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE64_ACQ */\n\
\n\
/* Define if you have _InterlockedCompareExchange64_rel() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE64_REL */\n\
\n\
/* Define if you have _InterlockedCompareExchange_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE_ACQ */\n\
\n\
/* Define if you have _InterlockedCompareExchange_rel() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDCOMPAREEXCHANGE_REL */\n\
\n\
/* Define if you have _InterlockedDecrement() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDDECREMENT */\n\
\n\
/* Define if you have _InterlockedDecrement64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDDECREMENT64 */\n\
\n\
/* Define if you have _InterlockedDecrement64_rel() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDDECREMENT64_REL */\n\
\n\
/* Define if you have _InterlockedDecrement_rel() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDDECREMENT_REL */\n\
\n\
/* Define if you have _InterlockedExchange() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGE */\n\
\n\
/* Define if you have _InterlockedExchange64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGE64 */\n\
\n\
/* Define if you have _InterlockedExchangeAdd() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGEADD */\n\
\n\
/* Define if you have _InterlockedExchangeAdd64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGEADD64 */\n\
\n\
/* Define if you have _InterlockedExchangeAdd64_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGEADD64_ACQ */\n\
\n\
/* Define if you have _InterlockedExchangeAdd_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDEXCHANGEADD_ACQ */\n\
\n\
/* Define if you have _InterlockedIncrement() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDINCREMENT */\n\
\n\
/* Define if you have _InterlockedIncrement64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDINCREMENT64 */\n\
\n\
/* Define if you have _InterlockedIncrement64_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDINCREMENT64_ACQ */\n\
\n\
/* Define if you have _InterlockedIncrement_acq() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDINCREMENT_ACQ */\n\
\n\
/* Define if you have _InterlockedOr() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDOR */\n\
\n\
/* Define if you have _InterlockedOr64() */\n\
/* #undef ETHR_HAVE__INTERLOCKEDOR64 */\n\
\n\
/* Define if you have __sync_add_and_fetch() for 32-bit integers */\n\
#define ETHR_HAVE___SYNC_ADD_AND_FETCH32 1\n\
\n\
/* Define if you have __sync_add_and_fetch() for 64-bit integers */\n\
#define ETHR_HAVE___SYNC_ADD_AND_FETCH64 1\n\
\n\
/* Define if you have __sync_fetch_and_and() for 32-bit integers */\n\
#define ETHR_HAVE___SYNC_FETCH_AND_AND32 1\n\
\n\
/* Define if you have __sync_fetch_and_and() for 64-bit integers */\n\
#define ETHR_HAVE___SYNC_FETCH_AND_AND64 1\n\
\n\
/* Define if you have __sync_fetch_and_or() for 32-bit integers */\n\
#define ETHR_HAVE___SYNC_FETCH_AND_OR32 1\n\
\n\
/* Define if you have __sync_fetch_and_or() for 64-bit integers */\n\
#define ETHR_HAVE___SYNC_FETCH_AND_OR64 1\n\
\n\
/* Define if you have __sync_val_compare_and_swap() for 128-bit integers */\n\
#define ETHR_HAVE___SYNC_VAL_COMPARE_AND_SWAP128 1\n\
\n\
/* Define if you have __sync_val_compare_and_swap() for 32-bit integers */\n\
#define ETHR_HAVE___SYNC_VAL_COMPARE_AND_SWAP32 1\n\
\n\
/* Define if you have __sync_val_compare_and_swap() for 64-bit integers */\n\
#define ETHR_HAVE___SYNC_VAL_COMPARE_AND_SWAP64 1\n\
\n\
/* Define if you want to modify the default stack size */\n\
/* #undef ETHR_MODIFIED_DEFAULT_STACK_SIZE */\n\
\n\
/* Define if you need the <nptl/pthread.h> header file. */\n\
/* #undef ETHR_NEED_NPTL_PTHREAD_H */\n\
\n\
/* Define if you have OSE style threads */\n\
/* #undef ETHR_OSE_THREADS */\n\
\n\
/* Define if you prefer gcc native ethread implementations */\n\
/* #undef ETHR_PREFER_GCC_NATIVE_IMPLS */\n\
\n\
/* Define if you prefer libatomic_ops native ethread implementations */\n\
/* #undef ETHR_PREFER_LIBATOMIC_OPS_NATIVE_IMPLS */\n\
\n\
/* Define if you have pthreads */\n\
#define ETHR_PTHREADS 1\n\
\n\
/* Define if pthread_yield() returns an int. */\n\
/* #undef ETHR_PTHREAD_YIELD_RET_INT */\n\
\n\
/* Define if sched_yield() returns an int. */\n\
#define ETHR_SCHED_YIELD_RET_INT 1\n\
\n\
/* Define to the size of AO_t if libatomic_ops is used */\n\
/* #undef ETHR_SIZEOF_AO_T */\n\
\n\
/* Define to the size of int */\n\
#define ETHR_SIZEOF_INT 4\n\
\n\
/* Define to the size of long */\n\
#define ETHR_SIZEOF_LONG 8\n\
\n\
/* Define to the size of long long */\n\
#define ETHR_SIZEOF_LONG_LONG 8\n\
\n\
/* Define to the size of pointers */\n\
#define ETHR_SIZEOF_PTR 8\n\
\n\
/* Define to the size of __int128_t */\n\
#define ETHR_SIZEOF___INT128_T 16\n\
\n\
/* Define to the size of __int64 */\n\
#define ETHR_SIZEOF___INT64 0\n\
\n\
/* Define if you want to enable check for native ethread implementations */\n\
#define ETHR_SMP_REQUIRE_NATIVE_IMPLS 1\n\
\n\
/* Define if only run in Sparc PSO, or TSO mode */\n\
/* #undef ETHR_SPARC_PSO */\n\
\n\
/* Define if run in Sparc RMO, PSO, or TSO mode */\n\
/* #undef ETHR_SPARC_RMO */\n\
\n\
/* Define if only run in Sparc TSO mode */\n\
/* #undef ETHR_SPARC_TSO */\n\
\n\
/* Define if you can safely include both <sys/time.h> and <time.h>. */\n\
#define ETHR_TIME_WITH_SYS_TIME 1\n\
\n\
/* Define if you have win32 threads */\n\
/* #undef ETHR_WIN32_THREADS */\n\
\n\
/* Define if x86/x86_64 out of order instructions should be synchronized */\n\
/* #undef ETHR_X86_OUT_OF_ORDER */\n\
\n\
/* Define if you want to use clock_gettime to simulate gethrtime */\n\
/* #undef GETHRTIME_WITH_CLOCK_GETTIME */\n\
\n\
/* Define if building a halfword-heap 64bit emulator */\n\
/* #undef HALFWORD_HEAP_EMULATOR */\n\
\n\
/* Define to 1 if you have the <arpa/nameser.h> header file. */\n\
#define HAVE_ARPA_NAMESER_H 1\n\
\n\
/* Define to 1 if you have the `brk' function. */\n\
#define HAVE_BRK 1\n\
\n\
/* define if clock_gettime() works for getting process time */\n\
/* #undef HAVE_CLOCK_GETTIME */\n\
\n\
/* Define to 1 if you have the `closefrom' function. */\n\
/* #undef HAVE_CLOSEFROM */\n\
\n\
/* Define if you have a decl of fread that conflicts with int fread */\n\
#define HAVE_CONFLICTING_FREAD_DECLARATION 1\n\
\n\
/* Define if you have a putenv() that stores a copy of the key-value pair */\n\
/* #undef HAVE_COPYING_PUTENV */\n\
\n\
/* Define if you have cpuset_getaffinity/cpuset_setaffinity */\n\
/* #undef HAVE_CPUSET_xETAFFINITY */\n\
\n\
/* Define to 1 if you have the declaration of `getrlimit', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_GETRLIMIT 1\n\
\n\
/* Define to 1 if you have the declaration of `IN6ADDR_ANY_INIT', and to 0 if\n\
   you don't. */\n\
#define HAVE_DECL_IN6ADDR_ANY_INIT 1\n\
\n\
/* Define to 1 if you have the declaration of `IN6ADDR_LOOPBACK_INIT', and to\n\
   0 if you don't. */\n\
#define HAVE_DECL_IN6ADDR_LOOPBACK_INIT 1\n\
\n\
/* Define to 1 if you have the declaration of `IPV6_V6ONLY', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_IPV6_V6ONLY 1\n\
\n\
/* Define to 1 if you have the declaration of `posix2time', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_POSIX2TIME 1\n\
\n\
/* Define to 1 if you have the declaration of `RLIMIT_STACK', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_RLIMIT_STACK 1\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_BOUND', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTPS_BOUND */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_COOKIE_ECHOED', and to 0\n\
   if you don't. */\n\
/* #undef HAVE_DECL_SCTPS_COOKIE_ECHOED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_COOKIE_WAIT', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTPS_COOKIE_WAIT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_ESTABLISHED', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTPS_ESTABLISHED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_IDLE', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTPS_IDLE */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_LISTEN', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTPS_LISTEN */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_SHUTDOWN_ACK_SENT', and\n\
   to 0 if you don't. */\n\
/* #undef HAVE_DECL_SCTPS_SHUTDOWN_ACK_SENT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_SHUTDOWN_PENDING', and to\n\
   0 if you don't. */\n\
/* #undef HAVE_DECL_SCTPS_SHUTDOWN_PENDING */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_SHUTDOWN_RECEIVED', and\n\
   to 0 if you don't. */\n\
/* #undef HAVE_DECL_SCTPS_SHUTDOWN_RECEIVED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTPS_SHUTDOWN_SENT', and to 0\n\
   if you don't. */\n\
/* #undef HAVE_DECL_SCTPS_SHUTDOWN_SENT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_ABORT', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_ABORT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_ADDR_CONFIRMED', and to 0\n\
   if you don't. */\n\
/* #undef HAVE_DECL_SCTP_ADDR_CONFIRMED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_ADDR_OVER', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTP_ADDR_OVER */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_BOUND', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_BOUND */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_CLOSED', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_CLOSED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_COOKIE_ECHOED', and to 0\n\
   if you don't. */\n\
/* #undef HAVE_DECL_SCTP_COOKIE_ECHOED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_COOKIE_WAIT', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTP_COOKIE_WAIT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_DELAYED_ACK_TIME', and to\n\
   0 if you don't. */\n\
/* #undef HAVE_DECL_SCTP_DELAYED_ACK_TIME */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_EMPTY', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_EMPTY */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_EOF', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_EOF */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_ESTABLISHED', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTP_ESTABLISHED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_LISTEN', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_LISTEN */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_SENDALL', and to 0 if you\n\
   don't. */\n\
/* #undef HAVE_DECL_SCTP_SENDALL */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_SHUTDOWN_ACK_SENT', and to\n\
   0 if you don't. */\n\
/* #undef HAVE_DECL_SCTP_SHUTDOWN_ACK_SENT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_SHUTDOWN_PENDING', and to\n\
   0 if you don't. */\n\
/* #undef HAVE_DECL_SCTP_SHUTDOWN_PENDING */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_SHUTDOWN_RECEIVED', and to\n\
   0 if you don't. */\n\
/* #undef HAVE_DECL_SCTP_SHUTDOWN_RECEIVED */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_SHUTDOWN_SENT', and to 0\n\
   if you don't. */\n\
/* #undef HAVE_DECL_SCTP_SHUTDOWN_SENT */\n\
\n\
/* Define to 1 if you have the declaration of `SCTP_UNORDERED', and to 0 if\n\
   you don't. */\n\
/* #undef HAVE_DECL_SCTP_UNORDERED */\n\
\n\
/* Define to 1 if you have the declaration of `setrlimit', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_SETRLIMIT 1\n\
\n\
/* Define to 1 if you have the declaration of `time2posix', and to 0 if you\n\
   don't. */\n\
#define HAVE_DECL_TIME2POSIX 1\n\
\n\
/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.\n\
   */\n\
#define HAVE_DIRENT_H 1\n\
\n\
/* Define to 1 if you have the <dlfcn.h> header file. */\n\
#define HAVE_DLFCN_H 1\n\
\n\
/* Define to 1 if you have the `dlopen' function. */\n\
#define HAVE_DLOPEN 1\n\
\n\
/* Define to 1 if you don't have `vprintf' but do have `_doprnt.' */\n\
/* #undef HAVE_DOPRNT */\n\
\n\
/* Define if you have the 'end' symbol */\n\
/* #undef HAVE_END_SYMBOL */\n\
\n\
/* Define if you have a working fallocate() */\n\
/* #undef HAVE_FALLOCATE */\n\
\n\
/* Define to 1 if you have the <fcntl.h> header file. */\n\
#define HAVE_FCNTL_H 1\n\
\n\
/* Define to 1 if you have the `fdatasync' function. */\n\
#define HAVE_FDATASYNC 1\n\
\n\
/* Define to 1 if you have the `finite' function. */\n\
#define HAVE_FINITE 1\n\
\n\
/* Define to 1 if you have the `flockfile' function. */\n\
#define HAVE_FLOCKFILE 1\n\
\n\
/* Define to 1 if you have the `fork' function. */\n\
#define HAVE_FORK 1\n\
\n\
/* Define to 1 if you have the `fpsetmask' function. */\n\
/* #undef HAVE_FPSETMASK */\n\
\n\
/* Define to 1 if you have the `fstat' function. */\n\
#define HAVE_FSTAT 1\n\
\n\
/* Define if you have fwrite_unlocked */\n\
/* #undef HAVE_FWRITE_UNLOCKED */\n\
\n\
/* Define to 1 if you have a good `getaddrinfo' function. */\n\
#define HAVE_GETADDRINFO 1\n\
\n\
/* Define to 1 if you have the `gethostbyname2' function. */\n\
#define HAVE_GETHOSTBYNAME2 1\n\
\n\
/* Define to flavour of gethostbyname_r */\n\
/* #undef HAVE_GETHOSTBYNAME_R */\n\
\n\
/* Define to 1 if you have the `gethrtime' function. */\n\
/* #undef HAVE_GETHRTIME */\n\
\n\
/* define if gethrvtime() works and uses ioctl() to /proc/self */\n\
/* #undef HAVE_GETHRVTIME_PROCFS_IOCTL */\n\
\n\
/* Define to 1 if you have the `getifaddrs' function. */\n\
#define HAVE_GETIFADDRS 1\n\
\n\
/* Define to 1 if you have the `getipnodebyaddr' function. */\n\
#define HAVE_GETIPNODEBYADDR 1\n\
\n\
/* Define to 1 if you have the `getipnodebyname' function. */\n\
#define HAVE_GETIPNODEBYNAME 1\n\
\n\
/* Define to 1 if you have a good `getnameinfo' function. */\n\
#define HAVE_GETNAMEINFO 1\n\
\n\
/* Define to 1 if you have the `gmtime_r' function. */\n\
#define HAVE_GMTIME_R 1\n\
\n\
/* Define to 1 if you have the <ieeefp.h> header file. */\n\
/* #undef HAVE_IEEEFP_H */\n\
\n\
/* Define to 1 if you have the `ieee_handler' function. */\n\
/* #undef HAVE_IEEE_HANDLER */\n\
\n\
/* Define to 1 if you have the <ifaddrs.h> header file. */\n\
#define HAVE_IFADDRS_H 1\n\
\n\
/* Define if ipv6 is present */\n\
#define HAVE_IN6 1\n\
\n\
/* Define to 1 if you have the variable in6addr_any declared. */\n\
#define HAVE_IN6ADDR_ANY 1\n\
\n\
/* Define to 1 if you have the variable in6addr_loopback declared. */\n\
#define HAVE_IN6ADDR_LOOPBACK 1\n\
\n\
/* Define to 1 if you have the `inet_pton' function. */\n\
#define HAVE_INET_PTON 1\n\
\n\
/* Define to 1 if you have the <inttypes.h> header file. */\n\
#define HAVE_INTTYPES_H 1\n\
\n\
/* Early linux used in_addr6 instead of in6_addr, define if you have this */\n\
/* #undef HAVE_IN_ADDR6_STRUCT */\n\
\n\
/* Define to 1 if you have the `isfinite' function. */\n\
#define HAVE_ISFINITE 1\n\
\n\
/* Define to 1 if you have the `isinf' function. */\n\
#define HAVE_ISINF 1\n\
\n\
/* Define to 1 if you have the `isnan' function. */\n\
#define HAVE_ISNAN 1\n\
\n\
/* Define if you have kstat */\n\
/* #undef HAVE_KSTAT */\n\
\n\
/* Define to 1 if you have the <langinfo.h> header file. */\n\
#define HAVE_LANGINFO_H 1\n\
\n\
/* Define to 1 if you have the `dl' library (-ldl). */\n\
#define HAVE_LIBDL 1\n\
\n\
/* Define to 1 if you have the `dlpi' library (-ldlpi). */\n\
/* #undef HAVE_LIBDLPI */\n\
\n\
/* Define to 1 if you have the <libdlpi.h> header file. */\n\
/* #undef HAVE_LIBDLPI_H */\n\
\n\
/* Define to 1 if you have the `inet' library (-linet). */\n\
/* #undef HAVE_LIBINET */\n\
\n\
/* Define to 1 if you have the `m' library (-lm). */\n\
#define HAVE_LIBM 1\n\
\n\
/* Define to 1 if you have the `util' library (-lutil). */\n\
#define HAVE_LIBUTIL 1\n\
\n\
/* Define to 1 if you have the `z' library (-lz). */\n\
#define HAVE_LIBZ 1\n\
\n\
/* Define to 1 if you have the <limits.h> header file. */\n\
#define HAVE_LIMITS_H 1\n\
\n\
/* Define to 1 if you have the <linux/falloc.h> header file. */\n\
/* #undef HAVE_LINUX_FALLOC_H */\n\
\n\
/* Define to 1 if you have the `localtime_r' function. */\n\
#define HAVE_LOCALTIME_R 1\n\
\n\
/* Define to 1 if you have the <malloc.h> header file. */\n\
/* #undef HAVE_MALLOC_H */\n\
\n\
/* Define to 1 if you have the `mallopt' function. */\n\
/* #undef HAVE_MALLOPT */\n\
\n\
/* Define to 1 if you have the `memcpy' function. */\n\
#define HAVE_MEMCPY 1\n\
\n\
/* Define to 1 if you have the `memmove' function. */\n\
#define HAVE_MEMMOVE 1\n\
\n\
/* Define to 1 if you have the <memory.h> header file. */\n\
#define HAVE_MEMORY_H 1\n\
\n\
/* Define if the pthread.h header file is in pthread/mit directory. */\n\
/* #undef HAVE_MIT_PTHREAD_H */\n\
\n\
/* Define to 1 if you have the `mlockall' function. */\n\
#define HAVE_MLOCKALL 1\n\
\n\
/* Define to 1 if you have the `mmap' function. */\n\
#define HAVE_MMAP 1\n\
\n\
/* Define to 1 if you have the `mremap' function. */\n\
/* #undef HAVE_MREMAP */\n\
\n\
/* Define if setsockopt() accepts multicast options */\n\
#define HAVE_MULTICAST_SUPPORT 1\n\
\n\
/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */\n\
/* #undef HAVE_NDIR_H */\n\
\n\
/* Define to 1 if you have the <netpacket/packet.h> header file. */\n\
/* #undef HAVE_NETPACKET_PACKET_H */\n\
\n\
/* Define to 1 if you have the <net/errno.h> header file. */\n\
/* #undef HAVE_NET_ERRNO_H */\n\
\n\
/* Define to 1 if you have the <net/if_dl.h> header file. */\n\
#define HAVE_NET_IF_DL_H 1\n\
\n\
/* Define to 1 if you have the `nl_langinfo' function. */\n\
#define HAVE_NL_LANGINFO 1\n\
\n\
/* Define if you don't have a definition of INADDR_LOOPBACK */\n\
/* #undef HAVE_NO_INADDR_LOOPBACK */\n\
\n\
/* Define to 1 if you have the `openpty' function. */\n\
#define HAVE_OPENPTY 1\n\
\n\
/* Define if you have the \"ose_spi/ose_spi.h\" header file. */\n\
/* #undef HAVE_OSE_SPI_H */\n\
\n\
/* Define to 1 if you have the `poll' function. */\n\
#define HAVE_POLL 1\n\
\n\
/* Define to 1 if you have the <poll.h> header file. */\n\
#define HAVE_POLL_H 1\n\
\n\
/* Define to 1 if you have the `posix2time' function. */\n\
#define HAVE_POSIX2TIME 1\n\
\n\
/* Define to 1 if you have the `posix_fadvise' function. */\n\
/* #undef HAVE_POSIX_FADVISE */\n\
\n\
/* Define if you have a working posix_fallocate() */\n\
/* #undef HAVE_POSIX_FALLOCATE */\n\
\n\
/* Define to 1 if you have the `posix_memalign' function. */\n\
#define HAVE_POSIX_MEMALIGN 1\n\
\n\
/* Define to 1 if you have the `pread' function. */\n\
#define HAVE_PREAD 1\n\
\n\
/* Define if you have processor_bind functionality */\n\
/* #undef HAVE_PROCESSOR_BIND */\n\
\n\
/* Define if you have pset functionality */\n\
/* #undef HAVE_PSET */\n\
\n\
/* Define if you have the <pthread.h> header file. */\n\
#define HAVE_PTHREAD_H 1\n\
\n\
/* Define to 1 if you have the <pty.h> header file. */\n\
/* #undef HAVE_PTY_H */\n\
\n\
/* Define if you have putc_unlocked */\n\
#define HAVE_PUTC_UNLOCKED 1\n\
\n\
/* Define to 1 if you have the `pwrite' function. */\n\
#define HAVE_PWRITE 1\n\
\n\
/* Define to 1 if you have the `res_gethostbyname' function. */\n\
/* #undef HAVE_RES_GETHOSTBYNAME */\n\
\n\
/* Define to 1 if you have the `sbrk' function. */\n\
#define HAVE_SBRK 1\n\
\n\
/* Define to 1 if you have the <sched.h> header file. */\n\
#define HAVE_SCHED_H 1\n\
\n\
/* Define if you have sched_getaffinity/sched_setaffinity */\n\
/* #undef HAVE_SCHED_xETAFFINITY */\n\
\n\
/* Define to 1 if you have the `sctp_bindx' function. */\n\
/* #undef HAVE_SCTP_BINDX */\n\
\n\
/* Define to 1 if you have the `sctp_freeladdrs' function. */\n\
/* #undef HAVE_SCTP_FREELADDRS */\n\
\n\
/* Define to 1 if you have the `sctp_freepaddrs' function. */\n\
/* #undef HAVE_SCTP_FREEPADDRS */\n\
\n\
/* Define to 1 if you have the `sctp_getladdrs' function. */\n\
/* #undef HAVE_SCTP_GETLADDRS */\n\
\n\
/* Define to 1 if you have the `sctp_getpaddrs' function. */\n\
/* #undef HAVE_SCTP_GETPADDRS */\n\
\n\
/* Define to 1 if you have the <netinet/sctp.h> header file */\n\
/* #undef HAVE_SCTP_H */\n\
\n\
/* Define to 1 if you have the `sctp_peeloff' function. */\n\
/* #undef HAVE_SCTP_PEELOFF */\n\
\n\
/* Define to 1 if you have the <sdkddkver.h> header file. */\n\
/* #undef HAVE_SDKDDKVER_H */\n\
\n\
/* Define to 1 if you have the `sendfile' function. */\n\
#define HAVE_SENDFILE 1\n\
\n\
/* Define to 1 if you have the `sendfilev' function. */\n\
/* #undef HAVE_SENDFILEV */\n\
\n\
/* Define to 1 if you have the `setlocale' function. */\n\
#define HAVE_SETLOCALE 1\n\
\n\
/* Define to 1 if you have the `setns' function. */\n\
/* #undef HAVE_SETNS */\n\
\n\
/* Define to 1 if you have the <setns.h> header file. */\n\
/* #undef HAVE_SETNS_H */\n\
\n\
/* Define to 1 if you have the `setsid' function. */\n\
#define HAVE_SETSID 1\n\
\n\
/* Define if we have socklen_t */\n\
#define HAVE_SOCKLEN_T 1\n\
\n\
/* define if you have the Solaris/ultrasparc /dev/perfmon interface */\n\
/* #undef HAVE_SOLARIS_SPARC_PERFMON */\n\
\n\
/* Define if you have SO_BSDCOMPAT flag on sockets */\n\
/* #undef HAVE_SO_BSDCOMPAT */\n\
\n\
/* Define to 1 if you have the <stdint.h> header file. */\n\
#define HAVE_STDINT_H 1\n\
\n\
/* Define to 1 if you have the <stdlib.h> header file. */\n\
#define HAVE_STDLIB_H 1\n\
\n\
/* Define to 1 if you have the `strerror' function. */\n\
#define HAVE_STRERROR 1\n\
\n\
/* Define to 1 if you have the `strerror_r' function. */\n\
#define HAVE_STRERROR_R 1\n\
\n\
/* Define to 1 if you have the <strings.h> header file. */\n\
#define HAVE_STRINGS_H 1\n\
\n\
/* Define to 1 if you have the <string.h> header file. */\n\
#define HAVE_STRING_H 1\n\
\n\
/* Define to 1 if you have the `strlcat' function. */\n\
#define HAVE_STRLCAT 1\n\
\n\
/* Define to 1 if you have the `strlcpy' function. */\n\
#define HAVE_STRLCPY 1\n\
\n\
/* Define to 1 if you have the `strncasecmp' function. */\n\
#define HAVE_STRNCASECMP 1\n\
\n\
/* Define to 1 if `ifr_enaddr' is member of `struct ifreq'. */\n\
/* #undef HAVE_STRUCT_IFREQ_IFR_ENADDR */\n\
\n\
/* Define to 1 if `ifr_hwaddr' is member of `struct ifreq'. */\n\
/* #undef HAVE_STRUCT_IFREQ_IFR_HWADDR */\n\
\n\
/* Define to 1 if `spp_flags' is member of `struct sctp_paddrparams'. */\n\
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_FLAGS */\n\
\n\
/* Define to 1 if `spp_pathmtu' is member of `struct sctp_paddrparams'. */\n\
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_PATHMTU */\n\
\n\
/* Define to 1 if `spp_sackdelay' is member of `struct sctp_paddrparams'. */\n\
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_SACKDELAY */\n\
\n\
/* Define to 1 if `sre_data' is member of `struct sctp_remote_error'. */\n\
/* #undef HAVE_STRUCT_SCTP_REMOTE_ERROR_SRE_DATA */\n\
\n\
/* Define to 1 if `ssf_data' is member of `struct sctp_send_failed'. */\n\
/* #undef HAVE_STRUCT_SCTP_SEND_FAILED_SSF_DATA */\n\
\n\
/* Define to 1 if you have the <syslog.h> header file. */\n\
#define HAVE_SYSLOG_H 1\n\
\n\
/* Define if you have systemd daemon */\n\
/* #undef HAVE_SYSTEMD_DAEMON */\n\
\n\
/* Define to 1 if you have the <systemd/sd-daemon.h> header file. */\n\
/* #undef HAVE_SYSTEMD_SD_DAEMON_H */\n\
\n\
/* Define if you have <sys/devpoll.h> header file. */\n\
/* #undef HAVE_SYS_DEVPOLL_H */\n\
\n\
/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.\n\
   */\n\
/* #undef HAVE_SYS_DIR_H */\n\
\n\
/* Define if you have the <sys/epoll.h> header file. */\n\
/* #undef HAVE_SYS_EPOLL_H */\n\
\n\
/* Define if you have <sys/event.h> header file. */\n\
#define HAVE_SYS_EVENT_H 1\n\
\n\
/* Define to 1 if you have the <sys/ioctl.h> header file. */\n\
#define HAVE_SYS_IOCTL_H 1\n\
\n\
/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.\n\
   */\n\
/* #undef HAVE_SYS_NDIR_H */\n\
\n\
/* Define to 1 if you have the <sys/resource.h> header file */\n\
#define HAVE_SYS_RESOURCE_H 1\n\
\n\
/* Define to 1 if you have the <sys/sdt.h> header file. */\n\
/* #undef HAVE_SYS_SDT_H */\n\
\n\
/* Define to 1 if you have the <sys/socketio.h> header file. */\n\
/* #undef HAVE_SYS_SOCKETIO_H */\n\
\n\
/* Define to 1 if you have the <sys/socket.h> header file. */\n\
#define HAVE_SYS_SOCKET_H 1\n\
\n\
/* Define to 1 if you have the <sys/sockio.h> header file. */\n\
#define HAVE_SYS_SOCKIO_H 1\n\
\n\
/* Define to 1 if you have the <sys/stat.h> header file. */\n\
#define HAVE_SYS_STAT_H 1\n\
\n\
/* Define to 1 if you have the <sys/stropts.h> header file. */\n\
/* #undef HAVE_SYS_STROPTS_H */\n\
\n\
/* Define to 1 if you have the <sys/sysctl.h> header file. */\n\
#define HAVE_SYS_SYSCTL_H 1\n\
\n\
/* Define to 1 if you have the <sys/time.h> header file. */\n\
#define HAVE_SYS_TIME_H 1\n\
\n\
/* Define to 1 if you have the <sys/types.h> header file. */\n\
#define HAVE_SYS_TYPES_H 1\n\
\n\
/* Define to 1 if you have the <sys/uio.h> header file. */\n\
#define HAVE_SYS_UIO_H 1\n\
\n\
/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */\n\
#define HAVE_SYS_WAIT_H 1\n\
\n\
/* Define if termcap functions exists */\n\
#define HAVE_TERMCAP 1\n\
\n\
/* Define to 1 if you have the `time2posix' function. */\n\
#define HAVE_TIME2POSIX 1\n\
\n\
/* Define to 1 if you have the <unistd.h> header file. */\n\
#define HAVE_UNISTD_H 1\n\
\n\
/* Define to 1 if you have the <util.h> header file. */\n\
#define HAVE_UTIL_H 1\n\
\n\
/* Define to 1 if you have the <utmp.h> header file. */\n\
#define HAVE_UTMP_H 1\n\
\n\
/* Define to 1 if you have the `vfork' function. */\n\
#define HAVE_VFORK 1\n\
\n\
/* Define to 1 if you have the <vfork.h> header file. */\n\
/* #undef HAVE_VFORK_H */\n\
\n\
/* Define to 1 if you have the `vprintf' function. */\n\
#define HAVE_VPRINTF 1\n\
\n\
/* Define to 1 if you have a `wcwidth' function. */\n\
#define HAVE_WCWIDTH 1\n\
\n\
/* Define to 1 if you have the <windows.h> header file. */\n\
/* #undef HAVE_WINDOWS_H */\n\
\n\
/* Define to 1 if you have the <winsock2.h> header file. */\n\
/* #undef HAVE_WINSOCK2_H */\n\
\n\
/* Define to 1 if `fork' works. */\n\
#define HAVE_WORKING_FORK 1\n\
\n\
/* Define if you have a working posix_openpt implementation */\n\
#define HAVE_WORKING_POSIX_OPENPT 1\n\
\n\
/* Define to 1 if `vfork' works. */\n\
#define HAVE_WORKING_VFORK 1\n\
\n\
/* Define to 1 if you have the `writev' function. */\n\
#define HAVE_WRITEV 1\n\
\n\
/* Define to 1 if you have the <ws2tcpip.h> header file. */\n\
/* #undef HAVE_WS2TCPIP_H */\n\
\n\
/* Define to 1 if you have the `_brk' function. */\n\
/* #undef HAVE__BRK */\n\
\n\
/* Define if you have the '_end' symbol */\n\
/* #undef HAVE__END_SYMBOL */\n\
\n\
/* Define to 1 if you have the `_sbrk' function. */\n\
/* #undef HAVE__SBRK */\n\
\n\
/* Define to 1 if you have the `__brk' function. */\n\
/* #undef HAVE___BRK */\n\
\n\
/* Define to 1 if you have the `__sbrk' function. */\n\
/* #undef HAVE___SBRK */\n\
\n\
/* Define to enable HiPE */\n\
#define HIPE 1\n\
\n\
/* define if h_errno is declared (in some way) in a system header file */\n\
#define H_ERRNO_DECLARED 1\n\
\n\
/* Define if netdb.h needs struct sockaddr_in ans in.h CAN be included before\n\
   */\n\
#define NETDB_H_NEEDS_IN_H 1\n\
\n\
/* Define if floating points exceptions are non-existing/not reliable */\n\
#define NO_FPE_SIGNALS \n\
\n\
/* Defined if no found C compiler can handle jump tables */\n\
/* #undef NO_JUMP_TABLE */\n\
\n\
/* Define if you dont have salen */\n\
/* #undef NO_SA_LEN */\n\
\n\
/* Define to the address where bug reports for this package should be sent. */\n\
#define PACKAGE_BUGREPORT \"\"\n\
\n\
/* Define to the full name of this package. */\n\
#define PACKAGE_NAME \"\"\n\
\n\
/* Define to the full name and version of this package. */\n\
#define PACKAGE_STRING \"\"\n\
\n\
/* Define to the one symbol short name of this package. */\n\
#define PACKAGE_TARNAME \"\"\n\
\n\
/* Define to the version of this package. */\n\
#define PACKAGE_VERSION \"\"\n\
\n\
/* Define if you wish to redefine FD_SETSIZE to be able to select on more fd\n\
   */\n\
/* #undef REDEFINE_FD_SETSIZE */\n\
\n\
/* Define as the return type of signal handlers (`int' or `void'). */\n\
#define RETSIGTYPE void\n\
\n\
/* Define the sbrk() argument type. */\n\
#define SBRK_ARG_TYPE int\n\
\n\
/* Define the sbrk() return type. */\n\
#define SBRK_RET_TYPE void *\n\
\n\
/* The size of a `AO_t', as computed by sizeof. */\n\
/* #undef SIZEOF_AO_T */\n\
\n\
/* The size of a `char', as computed by sizeof. */\n\
#define SIZEOF_CHAR 1\n\
\n\
/* The size of a `int', as computed by sizeof. */\n\
#define SIZEOF_INT 4\n\
\n\
/* The size of a `long', as computed by sizeof. */\n\
#define SIZEOF_LONG 8\n\
\n\
/* The size of a `long long', as computed by sizeof. */\n\
#define SIZEOF_LONG_LONG 8\n\
\n\
/* The size of a `off_t', as computed by sizeof. */\n\
#define SIZEOF_OFF_T 8\n\
\n\
/* The size of a `short', as computed by sizeof. */\n\
#define SIZEOF_SHORT 2\n\
\n\
/* The size of a `size_t', as computed by sizeof. */\n\
#define SIZEOF_SIZE_T 8\n\
\n\
/* The size of a `time_t', as computed by sizeof. */\n\
#define SIZEOF_TIME_T 8\n\
\n\
/* The size of a `void *', as computed by sizeof. */\n\
#define SIZEOF_VOID_P 8\n\
\n\
/* The size of a `__int128_t', as computed by sizeof. */\n\
#define SIZEOF___INT128_T 16\n\
\n\
/* The size of a `__int64', as computed by sizeof. */\n\
#define SIZEOF___INT64 0\n\
\n\
/* Define to 1 if you have the ANSI C header files. */\n\
#define STDC_HEADERS 1\n\
\n\
/* define if the variable sys_errlist is declared in a system header file */\n\
#define SYS_ERRLIST_DECLARED \n\
\n\
/* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */\n\
#define TIME_WITH_SYS_TIME 1\n\
\n\
/* Define to 1 if your <sys/time.h> declares `struct tm'. */\n\
/* #undef TM_IN_SYS_TIME */\n\
\n\
/* Define if you want to use dtrace for dynamic tracing */\n\
/* #undef USE_DTRACE */\n\
\n\
/* Define if you want to use dynamic tracing */\n\
/* #undef USE_DYNAMIC_TRACE */\n\
\n\
/* Define if you have matherr() function and struct exception type */\n\
#define USE_MATHERR 1\n\
\n\
/* Define to enable hrvtime() on Linux systems with perfctr extension */\n\
/* #undef USE_PERFCTR */\n\
\n\
/* Define if select() should be used instead of poll() */\n\
#define USE_SELECT 1\n\
\n\
/* Define if you want to use systemtap for dynamic tracing */\n\
/* #undef USE_SYSTEMTAP */\n\
\n\
/* Define to enable VM dynamic trace probes */\n\
/* #undef USE_VM_PROBES */\n\
\n\
/* Define if windows.h includes winsock2.h */\n\
/* #undef WINDOWS_H_INCLUDES_WINSOCK2_H */\n\
\n\
/* Define to 1 if your processor stores words with the most significant byte\n\
   first (like Motorola and SPARC, unlike Intel and VAX). */\n\
/* #undef WORDS_BIGENDIAN */\n\
\n\
/* Define to empty if `const' does not conform to ANSI C. */\n\
/* #undef const */\n\
\n\
/* Define to `long' if <sys/types.h> does not define. */\n\
/* #undef off_t */\n\
\n\
/* Define to `int' if <sys/types.h> does not define. */\n\
/* #undef pid_t */\n\
\n\
/* Define to `unsigned' if <sys/types.h> does not define. */\n\
/* #undef size_t */\n\
\n\
/* Define as `fork' if `vfork' does not work. */\n\
/* #undef vfork */\n\
\n\
\n\
/* Redefine in6_addr. XXX this should be moved to the files where it's used? */\n\
#ifdef HAVE_IN_ADDR6_STRUCT\n\
#define in6_addr in_addr6\n\
#endif\n\
\n\
/* Define a reasonable default for INADDR_LOOPBACK */\n\
/* XXX this should be moved to the files where it's used? */\n\
#ifdef HAVE_NO_INADDR_LOOPBACK\n\
#define INADDR_LOOPBACK (u_long)0x7F000001\n\
#endif\n\
\n\
#ifdef REDEFINE_FD_SETSIZE\n\
#define FD_SETSIZE 1024\n\
#endif\n\
\n\
#ifdef HAVE_GETHRVTIME_PROCFS_IOCTL\n\
#define HAVE_GETHRVTIME\n\
#endif\n\
\n\
#if !defined(HAVE_ISFINITE) && !defined(HAVE_FINITE)\n\
# if defined(HAVE_ISINF) && defined(HAVE_ISNAN)\n\
#  define USE_ISINF_ISNAN\n\
# endif\n\
#endif\n\
\n\
#if defined(DEBUG) && defined(USE_THREADS) && !defined(ERTS_ENABLE_LOCK_CHECK)\n\
#define ERTS_ENABLE_LOCK_CHECK 1\n\
#endif\n\
\n\
";
const char* erts_build_flags_LDFLAGS = "-m64 ";
