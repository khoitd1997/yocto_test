# there is a static lib in bfd-plugins/libdep.a of binutils that cause the fail
# since static libs are not allowed in packages without -staticdev postfix
# this is not a major issue so skip the check
INSANE_SKIP += "staticdev"