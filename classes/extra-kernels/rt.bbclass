RT_KERNEL_COMMON_ARGS ?= "processor.max_cstate=0 intel.max_cstate=0 processor_idle.max_cstate=0 intel_idle.max_cstate=0 clocksource=tsc tsc=reliable nowatchdog intel_pstate=disable idle=poll noht isolcpus=2,3 rcu_nocbs=all rcupdate.rcu_cpu_stall_suppress=1 rcu_nocb_poll irqaffinity=0 i915.enable_rc6=0 i915.enable_dc=0 i915.disable_power_well=0 mce=off hpet=disable numa_balancing=disable igb.blacklist=no efi=runtime art=virtallow"
