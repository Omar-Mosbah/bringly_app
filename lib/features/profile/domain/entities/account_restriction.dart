enum AccountRestriction { active, suspended, blocked, forcedLogoutRequired }

extension AccountRestrictionX on AccountRestriction {
  bool get blocksProtectedMarketplace {
    return this == AccountRestriction.suspended ||
        this == AccountRestriction.blocked ||
        this == AccountRestriction.forcedLogoutRequired;
  }
}