{
  buildLinux,
  lib,
  fetchFromGitHub,
  overrideCC,
  llvmPackages_latest,
  ...
}@args:
buildLinux (
  args
  // rec {
    stdenv = overrideCC llvmPackages_latest.stdenv (
      # Tell our C compiler (Clang) to use LLVM bintools--normally GNU
      # binutils are used even with Clang as the compiler.
      llvmPackages_latest.stdenv.cc.override {
        bintools = llvmPackages_latest.bintools;
      }
    );

    pname = "linux-zen-myria";
    version = "6.15.4-zen1";
    suffix = "zen1";
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";

    # Tell Linux that we're compiling with Clang and LLVM.
    extraMakeFlags = [
      "LLVM=1"
      "RUST=1"
    ];
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
    };
    # This is based on the following sources:
    # - zen: https://gitlab.archlinux.org/archlinux/packaging/packages/linux-zen/-/blob/main/config
    # - lqx: https://github.com/damentz/liquorix-package/blob/6.13/master/linux-liquorix/debian/config/kernelarch-x86/config-arch-64
    # - Liquorix features: https://liquorix.net/
    # The list below is not exhaustive, so the kernels probably doesn't match
    # the upstream, but should bring most of the improvements that will be
    # expected by users
    structuredExtraConfig = {
      # Optimisation flags
      MZEN4 = lib.kernel.yes;
      CC_OPTIMIZE_FOR_PERFORMANCE_O3 = lib.kernel.yes;

      # Clang flags
      CFI_CLANG = lib.kernel.yes;
      LTO_CLANG_FULL = lib.kernel.yes;
      RUST = lib.kernel.yes;

      # Zen Interactive tuning
      ZEN_INTERACTIVE = lib.kernel.yes;

      # FQ-Codel Packet Scheduling
      NET_SCH_DEFAULT = lib.kernel.yes;
      DEFAULT_FQ_CODEL = lib.kernel.yes;

      # Preempt (low-latency)
      PREEMPT = lib.mkOverride 90 lib.kernel.yes;
      PREEMPT_VOLUNTARY = lib.mkOverride 90 lib.kernel.no;

      # Preemptible tree-based hierarchical RCU
      TREE_RCU = lib.kernel.yes;
      PREEMPT_RCU = lib.kernel.yes;
      RCU_EXPERT = lib.kernel.yes;
      TREE_SRCU = lib.kernel.yes;
      TASKS_RCU_GENERIC = lib.kernel.yes;
      TASKS_RCU = lib.kernel.yes;
      TASKS_RUDE_RCU = lib.kernel.yes;
      TASKS_TRACE_RCU = lib.kernel.yes;
      RCU_STALL_COMMON = lib.kernel.yes;
      RCU_NEED_SEGCBLIST = lib.kernel.yes;
      RCU_FANOUT = lib.kernel.freeform "64";
      RCU_FANOUT_LEAF = lib.kernel.freeform "16";
      RCU_BOOST = lib.kernel.yes;
      RCU_BOOST_DELAY = lib.kernel.option (lib.kernel.freeform "500");
      RCU_NOCB_CPU = lib.kernel.yes;
      RCU_LAZY = lib.kernel.yes;
      RCU_DOUBLE_CHECK_CB_TIME = lib.kernel.yes;

      # BFQ I/O scheduler
      IOSCHED_BFQ = lib.mkOverride 90 lib.kernel.yes;

      # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
      FUTEX = lib.kernel.yes;
      FUTEX_PI = lib.kernel.yes;

      # NT synchronization primitive emulation
      NTSYNC = lib.kernel.yes;

      # Preemptive Full Tickless Kernel at 1000Hz
      HZ = lib.kernel.freeform "1000";
      HZ_1000 = lib.kernel.yes;

    };

  }
  // (args.argsOverride or { })
)
