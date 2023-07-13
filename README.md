## Upgradeable-Proxy 

ERC1967 upgradeable proxy patterns introduced in this repo...

Two implementation contracts exist

proxy  ------> BoxV1  
Proxy starts with implementation BoxV1
    
proxy  ------> BoxV2

Using BoxV1 abi to communicate with proxy contract to activate the implementation logic 

BoxV1(proxyAddress).upgradeTo(address(BoxV2)) ---> This will change the implementation to BoxV2



