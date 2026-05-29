enum MarketplaceRole { shopper, traveler, both, unavailable }

extension MarketplaceRoleX on MarketplaceRole {
  bool get supportsShopping {
    return this == MarketplaceRole.shopper || this == MarketplaceRole.both;
  }

  bool get supportsTravel {
    return this == MarketplaceRole.traveler || this == MarketplaceRole.both;
  }
}