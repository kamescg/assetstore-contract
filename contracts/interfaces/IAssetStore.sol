// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import { IStringValidator } from './IStringValidator.sol';

// IAssetStore is the inteface for consumers of the AsseStore.
interface IAssetStore {
  // Browsing
  function getGroupCount() external view returns(uint32);
  function getGroupNameAtIndex(uint32 _groupIndex) external view returns(string memory);
  function getCategoryCount(string memory _group) external view returns(uint32);
  function getCategoryNameAtIndex(string memory _group, uint32 _categoryIndex) external view returns(string memory);
  function getAssetCountInCategory(string memory _group, string memory _category) external view returns(uint32);
  function getAssetIdInCategory(string memory _group, string memory _category, uint32 _assetIndex) external view returns(uint256);
  function getAssetIdWithName(string memory _group, string memory _category, string memory _name) external view returns(uint256);

  // Fetching
  struct AssetAttributes {
    string group;
    string category;
    string name;
    string tag; // the id in SVG
    string minter; // the name of the minter (who paid the gas fee)
    address soulbound; // wallet address of the minter
    bytes metadata; // group/category specific metadata
    uint16 width;
    uint16 height;
  }

  function generateSVG(uint256 _assetId) external view returns(string memory);
  function generateSVGPart(uint256 _assetId, string memory _tag) external view returns(string memory);
  function getAttributes(uint256 _assetId) external view returns(AssetAttributes memory);
  function getStringValidator() external view returns(IStringValidator);
}

// HACK: Created after the deployment of AssetStore
interface IAssetStoreEx is IAssetStore {
  function getAssetCount() external view returns(uint256);
}

// IAssetStoreRegistry is the interface for contracts who registers assets to the AssetStore.
interface IAssetStoreRegistry {
  struct Part {
    bytes body;
    string color;
  }

  struct AssetInfo {
    string group;
    string category;
    string name;
    string minter; // the name of the minter, who is paying the gas fee
    address soulbound; // wallet address of the minter
    bytes metadata; // group/category specific metadata (optional)
    Part[] parts;
  }

  event AssetRegistered(address from, uint256 assetId);
  event GroupAdded(string group);
  event CategoryAdded(string group, string category);

  function registerAsset(AssetInfo memory _assetInfo) external returns(uint256);
  function registerAssets(AssetInfo[] memory _assetInfos) external;
}