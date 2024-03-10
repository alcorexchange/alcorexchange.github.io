---
title: Alcor API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - javascript

toc_footers:
  - <a href='https://docs.alcor.exchange'>Documentation & APIv1</a>

includes:
  - errors

search: true

code_clipboard: true

meta:
  - name: description
    content: Alcor Exchange API documentation
---

# Introduction
Alcor Exchange has HTTP and WebSocket api. Which can get information on various markets, orderboos, prices, events, and charts.
WebSocket allows streaming for orderbook updates, new deals, and account events.

Interaction with Alcor is divided into 2 types:

* **Interaction with the contract.**
    * Place/Cancel order.
    * Add/Remove LP position.
* **Obtaining information about the markets using the Alcor API services.**
    * Market Data
    * Liquidity pools Data
    * WebSocket Stream

Basic documentation can be found here: [docs.alcor.exchange](https://docs.alcor.exchange/)

#### URL Structure
HTTP API URL are separated by chains using following structute.
The UI are following same structute as api, they are splitted by subdomains named by chain.

Chain | URL
---------- | ---------
WAX | <b>https://wax.alcor.exchange/api/v2/</b>
EOS | <b>https://eos.alcor.exchange/api/v2/</b>
Proton | <b>https://proton.alcor.exchange/api/v2/</b>
Telos | <b>https://telos.alcor.exchange/api/v2/</b>


<aside class="notice">
All timestamp's are expected to be in milliseconds
</aside>


<aside class="notice">
    Alcor API can be used only for retrieve data. For interacting with blockchain(place/cancel order) use NODE API.
</aside>

## Node API
```javascript
import fetch from 'node-fetch'
import { Api, JsonRpc, RpcError, JsSignatureProvider } from 'eosjs'

const rpc = new JsonRpc('https://eos.greymass.com', { fetch })
const signatureProvider = new JsSignatureProvider(['private key of order owner'])
const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
```
Alcor is DEX, so, intereations with exchange, such as placing new order or order cancel, requires work with <b>blockchain node api directly</b>.
Examples can be found in **Trading API** section.


Alcor support multiple EOSIO blockchains. Here is dex contract accounts across supported cahins:

- WAX - alcordexmain
- EOS - eostokensdex
- TELOS - eostokensdex
- Proton - alcor

You can easly interacting with alcor contracts using **[EOSJS library](https://github.com/EOSIO/eosjs)**. 

Alternatives:

* [greymass/eosio-core](https://github.com/greymass/eosio-core)
* [eosnetworkfoundation/mandel-eosjs](https://github.com/eosnetworkfoundation/mandel-eosjs)


# Tokens

## Token price
```shell
curl https://alcor.exchange/api/v2/tokens/tlm-alien.worlds

```

> The above command returns JSON structured like this:

```json
{
  "contract": "alien.worlds",
  "decimals": 4,
  "symbol": "TLM",
  "id": "tlm-alien.worlds",
  "system_price": 0.252009,
  "usd_price": 0.010197
}
```

Get single token price by id

### HTTP Request

`GET https://alcor.exchange/api/v2/tokens/:<token_id>`

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
contract | string | token contract
decimals | number | token precision
symbol | string | token symbol
id | string | token-id
system_price | number | token price in chain system token
usd_price | number | token price in USD

## All tokens prices
```shell
curl https://alcor.exchange/api/v2/tokens
```

> The above command returns JSON structured like this:

```json
[
  {
    "contract": "alien.worlds",
    "decimals": 4,
    "symbol": "TLM",
    "id": "tlm-alien.worlds",
    "system_price": 0.252009,
    "usd_price": 0.010197
  },
  ...
]
```

Get all tokens with it's prices

### HTTP Request

`GET https://alcor.exchange/api/v2/tokens`

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
contract | string | token contract
decimals | number | token precision
symbol | string | token symbol
id | string | token-id
system_price | number | token price in chain system token
usd_price | number | token price in USD

# Global Data

## Stats
Returns global data on TVL, volumes, number of trading pairs, and so on

<aside class="notice">
  All volume values are displayed in USD
</aside>

```shell
curl "https://alcor.exchange/api/v2/analytics/global"
```

> The above command returns JSON structured like this:

```json
{
  "_id": "wax",
  "totalValueLocked": 2240718.758763486,
  "swapValueLocked": 943995.9929317994,
  "spotValueLocked": 1296722.7658316866,
  "swapTradingVolume": 344377.66920321307,
  "spotTradingVolume": 26406.316737205285,
  "swapFees": 1063.6217236406346,
  "spotFees": 409.7303415365396,
  "dailyActiveUsers": 4063,
  "swapTransactions": 26347,
  "spotTransactions": 3163,
  "totalLiquidityPools": 1483,
  "totalSpotPairs": 808,
  "totalTradingVolume": 370783.9859404183
}
```

### HTTP Request

`GET https://alcor.exchange/api/v2/analytics/global`

**Query params:**

Name | Type | Description | Default
--- | --- | --- | ---
resolution | string | Accumulate results over a certain period of time | 1D

**Supported resolutions:**

`1D, 1W, 1M`

### Responce

Name | Type | Description
---------- | --------------------------- | -----------
totalValueLocked | number | Exchange TVL
swapValueLocked | number | Total AMM Value locked in USD
spotValueLocked | number | Total spot value locked in open orders
swapTradingVolume | number | AMM trading volume
spotTradingVolume | number | Spot trading volume
swapFees | number | AMM fees
spotFees | number | Spot fees
dailyActiveUsers | number | avg Daily active users
swapTransactions | number | Total AMM swaps for period(resolution)
spotTransactions | number | Total spot trades for period(resolution)
totalLiquidityPools | number | Count of AMM pairs
totalSpotPairs | number | Count of spot pairs
totalTradingVolume | number | Total trading volume for given period(resolution)

# Market Data
Token symbol repesented as <b>SYMBOL_contract</b>
following the eosio.token standard. As the one symbol can be deployed by multiple contracts.

## Trading pairs
Provides a list of all trading pairs on the Alcor DEX.

```shell
curl "https://alcor.exchange/api/v2/pairs"
```

> The above command returns JSON structured like this:

```json
[
  {
    "base": {
      "id": "pgl-prospectorsw",
      "contract": "prospectorsw",
      "symbol": "PGL",
      "precision": 4
    },
    "target": {
      "id": "wax-eosio.token",
      "contract": "eosio.token",
      "symbol": "WAX",
      "precision": 8
    },
    "ticker_id": "pgl-prospectorsw_wax-eosio.token"
  }
]
```

### HTTP Request

`GET https://alcor.exchange/api/v2/pairs`

**Query params:**

Name | Type | Description
--- | --- | ---
base | string | Filter pair by base currency id
target | string | Filter pair by target currency id

ie: `https://alcor.exchange/api/v2/pairs?base=tlm-alien.worlds`

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker with delimiter to separate base/target
base | string | Symbol code of a the base cryptoasset
target | string | Symbol code of the target cryptoasset

<aside class="notice">
    In EOSIO eny contract can be deployed as token and have any Symbol.
    Therefore the unique identifier contains the name of the contract to avoid confusion.
</aside>



## Ticker
```shell
curl "https://alcor.exchange/api/v2/tickers/tlm-alien.worlds_wax-eosio.token"
```
> The above command returns JSON structured like this:

```json
{
    "ticker_id": "tlm-alien.worlds_wax-eosio.token",
    "market_id": 26,
    "target_currency": "wax-eosio.token",
    "base_currency": "tlm-alien.worlds",
    "target_cmc_ucid": 825,
    "base_cmc_ucid": 2300
    "min_buy": "0.50000000 WAX",
    "min_sell": "1.0000 TLM",
    "last_price": 0.32448004,
    "change24": 3.42,
    "high24": 0.34088342,
    "low24": 0.30488872,
    "bid": 0.32448004,
    "ask": 0.32580358,
    "base_volume": 100178.36015088,
    "target_volume": 314152.7801
    "frozen": false,
    "fee": 20,
}
```

Endpoint provides pricing and volume information on sprcific ticker.

Ticker ID represented as base token (Symbol-contract) _ quote_token (Symbol-contract)
example: <b>rda-deadcitytokn_wax-eosio.token</b>


### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id`

### Query Parameters

Parameter | Mandatory | Type | Description
--------- | ------- | ----------- | --
ticker_id | true | string | Ticker id

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker
base_currency | string | Symbol code of a the base cryptoasset
target_currency | string | Symbol code of the target cryptoasset
target_cmc_ucid | number | CMC integration target token UCID
base_cmc_ucid | number | CMC integration base token UCID
min_buy | string | Minimum amount of target currency
min_sell | string | Minimum amount of base currency
last_price | number | Price of the latest deal
change24 | number | Price change in 24 hours positive/negative
high24 | number | Highest price in 24 hours
low24 | number | Lowest price in 24
bid | number | Price of current highest buy order
ask | number | Price of current cheapest sell order
base_volume | number | 24H Volume of base currency
target_volume | number | 24H Volume of target currency
frozen | boolean | Trading are frozen
fee | number | Market fees represented as % of 1000 (fee / 1000)



## Tickers
```shell
curl "https://alcor.exchange/api/v2/tickers"
```
> The above command returns JSON structured like this:

```json
[
    {
        "ticker_id": "tlm-alien.worlds_wax-eosio.token",
        "market_id": 26,
        "target_currency": "wax-eosio.token",
        "base_currency": "tlm-alien.worlds",
        "min_buy": "0.50000000 WAX",
        "min_sell": "1.0000 TLM",
        "last_price": 0.32448004,
        "change24": 3.42,
        "high24": 0.34088342,
        "low24": 0.30488872,
        "bid": 0.32448004,
        "ask": 0.32580358,
        "base_volume": 100178.36015088,
        "target_volume": 314152.7801
        "frozen": false,
        "fee": 20,
        "target_cmc_ucid": 2300,
        "base_cmc_ucid": 9119
    }
]
```

Endpoint provides pricing and volume information on each market pair available on an exchange.


### HTTP Request

`GET https://alcor.exchange/api/v2/tickers`

Without parameters returns all available tickers

### Query Parameters

Parameter | Mandatory | Type | Description
--------- | ------- | ----------- | --
tickers | false | array | Array of ticker_id's, for getting only selected tickers

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker
base_currency | string | Symbol code of a the base cryptoasset
target_currency | string | Symbol code of the target cryptoasset
min_buy | string | Minimum amount of target currency
min_sell | string | Minimum amount of base currency
last_price | number | Price of the latest deal
change24 | number | Price change in 24 hours positive/negative
high24 | number | Highest price in 24 hours
low24 | number | Lowest price in 24
bid | number | Price of current highest buy order
ask | number | Price of current cheapest sell order
base_volume | number | 24H Volume of base currency
target_volume | number | 24H Volume of target currency
frozen | boolean | Trading are frozen
fee | number | Market fees represented as 0.01%
target_cmc_ucid | number | target Unified Cryptoasset ID if exist or null
base_cmc_ucid | numer | base Unified Cryptoasset ID if exist or null


## Orderbook
```shell
curl "https://alcor.exchange/api/v2/tickers/pgl-prospectorsw_wax-eosio.token/orderbook?depth=3"
```
> The above command returns JSON structured like this:

```json
{
    "ticker_id": "PGL-prospectorsw_WAX-eosio.token",
    "asks": [
        [
            "0.66299999", // PRICE
            "111.8101" // QTY
        ],
        [
            "0.66300000",
            "237.5000"
        ],
        [
            "0.66400000",
            "500.0000"
        ],
    ],
    "bids": [
        [
            "0.64800031",
            "74.51997085"
        ],
        [
            "0.64800030",
            "87.64158563"
        ],
        [
            "0.64598927",
            "150.00000000"
        ],
    ]
}
```

Endpoint using to provide order book information with at least depth = 3 returned for a given ticker. 

### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id/orderbook`

### Query Parameters

Parameter | Mandatory | Default | Description
--------- | ------- | ----------- | --
ticker_id | true | string | ticker id
depth | false | 300 | The number of market depth to return on each side

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker with delimiter to separate base/target
bids | array | Array of bids. bid structure: [price, quantity]
asks | array | Array of asks. ask structure: [price, quantity]


## Latest Trades
Retrieve the most recent deals of a ticker, sorted by time from latest to oldest.

```shell
curl "https://alcor.exchange/api/v2/tickers/pgl-prospectorsw_wax-eosio.token/latest_trades?limit=2"
```
> The above command returns JSON structured like this:

```json
[
    {
        "trade_id": "61a0fd5b5f0f4674848b26ae",
        "base_volume": 48.8126,
        "target_volume": 29.52941386,
        "price": 0.604955,
        "time": 1637929769500,
        "type": "buy"
    },
    {
        "trade_id": "61a0fcf65f0f4674848b0cf4",
        "base_volume": 12.9939,
        "target_volume": 7.86070962,
        "price": 0.60495104,
        "time": 1637929668000,
        "type": "sell"
    }
]
```

### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id/latest_trades`

### Query Parameters

Parameter | Mandatory | Default | Description
--------- | ------- | ----------- | --
limit | false | 300 | The number of latest trades to return


## Trade history
Retrieve the recent transactions of an instrument, sorted by time from earlyer to latest.

```shell
curl "https://alcor.exchange/api/v2/tickers/pgl-prospectorsw_wax-eosio.token/historical_trades?limit=2"
```
> The above command returns JSON structured like this:

```json
[
    {
        "base_volume": 48.8126,
        "price": 0.604955,
        "target_volume": 29.52941386,
        "time": 1637929769500,
        "trade_id": "61a0fd5b5f0f4674848b26ae",
        "type": "buy"
    },
    {
        "base_volume": 12.9939,
        "price": 0.60495104,
        "target_volume": 7.86070962,
        "time": 1637929668000,
        "trade_id": "61a0fcf65f0f4674848b0cf4",
        "type": "sell"
    }
]
```

Endpoint using to return data on historical completed trades for a given ticker.

### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id/historical_trades`

Sorting from lasted to oldest deals

### Query Parameters

Parameter | Type | Description
--------- | ------- | --------
type | string | Filter by "sell" or "buy" trades
limit | integer | Number of trades to retrieve
step | integer | Offset, used for step-by-step loading of the entire history
from | timestamp | Start time from which to query trades (milliseconds)
to | timestamp | End time for historical trades (milliseconds)

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
trade_id | string | A unique ID associated with the trade
price | decimal | Transaction price.
base_volume | decimal | Transaction amount in base pair volume
target_volume | decimal | Transaction amount in target pair volume.
time | timestamp | Unix timestamp in milliseconds for when the transaction occurred.
type | string |  Type of the transaction that was completed.

## Klines (Candles)
```shell
curl "https://alcor.exchange/api/v2/tickers/pgl-prospectorsw_wax-eosio.token/charts?resolution=60&from=1637856799500&to=1637869859000"
```

> The above command returns JSON structured like this:

```json
[
    {
        "close": 0.57009415,
        "high": 0.58999718,
        "low": 0.57009415,
        "open": 0.58999718,
        "time": 1637856799500,
        "volume": 1.34580567 // Volume in TARGET currency
    },
    {
        "close": 0.5889,
        "high": 0.5889,
        "low": 0.553,
        "open": 0.57009415,
        "time": 1637859602500,
        "volume": 817.85241392
    }
]
```
This endpoint retrieves klines for specific ticker in a specific range.

### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id/charts`


### Query Parameters

from, to, resolution, limit

Parameter | Mandatory | Type | Description
--------- | ------- | ----------- | ---------
ticker_id | true | string | Ticker id
resolution | true | string | Resolution
from | false | timestamp | Start time for getting historical candles
to | false | timestamp | End time till which query candles

**Supported resolutions:**

`1, 5, 15, 30, 60, 240, 1D, 1W, 1M`

# Swap
Alcor is a protocol based on the AMM concept using concentrated liquidity. Allowing you to change one eosio.token to another.
<aside class="notice">
A detailed description of the principle of operation can be found in the documentation: [Alcor Swap
Docs](https://docs.alcor.exchange/alcor-swap/introduction) and [Amm Swap Contract API](https://docs.alcor.exchange/developers-api/amm-swap-contract-api)

And special [Alcor Swap SDK](https://github.com/alcorexchange/alcor-v2-sdk) for calculating everything locally, without
API.
</aside>

## Pool
```shell
curl https://alcor.exchange/api/v2/swap/pools/0
```

Get pool by ID

> The above command returns JSON structured like this:

```json
{
  "chain": "wax",
  "id": 1095,
  "active": true,
  "fee": 3000,
  "feeGrowthGlobalAX64": "212803631582389957186",
  "feeGrowthGlobalBX64": "1171129874747599",
  "feeProtocol": 3,
  "liquidity": "951789470700",
  "maxLiquidityPerTick": "1247497401346422",
  "protocolFeeA": 10681.09414088,
  "protocolFeeB": 703.6308,
  "sqrtPriceX64": "45802571509710763",
  "tick": -119973,
  "tickSpacing": 60,
  "tokenA": {
    "contract": "eosio.token",
    "decimals": 8,
    "symbol": "WAX",
    "id": "wax-eosio.token",
    "quantity": 1413257.13064633
  },
  "tokenB": {
    "contract": "usdt.alcor",
    "decimals": 4,
    "symbol": "USDT",
    "id": "usdt-usdt.alcor",
    "quantity": 81673.5964
  },
  "volumeA24": 60225.61186526,
  "volumeAMonth": 12102207.71289808,
  "volumeAWeek": 2865840.95504714,
  "volumeB24": 3703.4195999999997,
  "volumeBMonth": 823163.2468,
  "volumeBWeek": 175806.8865,
  "volumeUSD24": 7440.385309538387,
  "volumeUSDMonth": 1649849.915091903,
  "volumeUSDWeek": 353479.23752087017,
  "tvlUSD": 168895.21809226653,
  "change24": 0.3,
  "changeWeek": -0.49,
  "high24": 0,
  "low24": 0,
  "priceA": 0.0623307,
  "priceB": 16.0435
}
```

**Query params:**

Pool id should be provided inside the URL structure

Name | Type | Description | required
--- | --- | --- | ---
pool_id | number | Pool ID | true

### HTTP Request
`GET https://alcor.exchange/api/v2/swap/pools/:<pool_id>`

### Responce
Name | Type | Description
--- | --- | --- | ---
id | number | pool ID
active | number | is pool active
fee | number | fee percent as part of (fee / 10000)
feeGrowthGlobalAX64 | number | Global accumulated fee for token A
feeGrowthGlobalBX64 | number | Global accumulated fee for token B
feeProtocol | number | Protocol fee percent
liquidity | number | Pool liquidity amount
maxLiquidityPerTick | number | Pool max liquidity ber one tick
protocolFeeA | asset | Protocol earned fees
protocolFeeB | asset | Protocol earned fees
sqrtPriceX64 | number | Pool price as sqrtPriceX64
tick | number | Pool current tick
tickSpacing | number | Pool tick spacing
tokenA | object | Token A
tokenB | object | Token B
volumeUSD24 | number | USD Volume for 24H
volumeUSDWeek | number | USD Volume for 7D
volumeUSDMonth | number | USD Volume for 30D
volumeA24 | number | 24H volume of token A
volumeAWeek | number | 7D volume of token A
volumeAMonth | number | 30D volume of token A
volumeB24 | number | 24H volume of token B
volumeBWeek | number | 7D volume of token B
volumeBMonth | number | 30D volume of token B
volumeUSD24 | number | USD Volume for 24H
volumeUSDWeek | number | USD Volume for 7D
volumeUSDMonth | number | USD Volume for 30D
tvlUSD | number | Total Value Locked in USD
change24 | number | 24H price change
changeWeek | number | 7D price change
high24 | number | 24H price high
low24 | number | 24H price low
priceA | number | token A price in terms of token B
priceB | number | token B price in terms of token A


## Pools
```shell
curl https://alcor.exchange/api/v2/swap/pools
```

Get all swap pools

> The above command returns JSON structured like this:

```json
[
  {
    "chain": "wax",
    "id": 1095,
    "active": true,
    "fee": 3000,
    "feeGrowthGlobalAX64": "212803631582389957186",
    "feeGrowthGlobalBX64": "1171129874747599",
    "feeProtocol": 3,
    "liquidity": "951789470700",
    "maxLiquidityPerTick": "1247497401346422",
    "protocolFeeA": 10681.09414088,
    "protocolFeeB": 703.6308,
    "sqrtPriceX64": "45802571509710763",
    "tick": -119973,
    "tickSpacing": 60,
    "tokenA": {
      "contract": "eosio.token",
      "decimals": 8,
      "symbol": "WAX",
      "id": "wax-eosio.token",
      "quantity": 1413257.13064633
    },
    "tokenB": {
      "contract": "usdt.alcor",
      "decimals": 4,
      "symbol": "USDT",
      "id": "usdt-usdt.alcor",
      "quantity": 81673.5964
    },
    "volumeA24": 60225.61186526,
    "volumeAMonth": 12102207.71289808,
    "volumeAWeek": 2865840.95504714,
    "volumeB24": 3703.4195999999997,
    "volumeBMonth": 823163.2468,
    "volumeBWeek": 175806.8865,
    "volumeUSD24": 7440.385309538387,
    "volumeUSDMonth": 1649849.915091903,
    "volumeUSDWeek": 353479.23752087017,
    "tvlUSD": 168895.21809226653,
    "change24": 0.3,
    "changeWeek": -0.49,
    "high24": 0,
    "low24": 0,
    "priceA": 0.0623307,
    "priceB": 16.0435
  }
  ...
]
```

### HTTP Request
`GET https://alcor.exchange/api/v2/swap/pools`

### Responce
Name | Type | Description
--- | --- | --- | ---
id | number | pool ID
active | number | is pool active
fee | number | fee percent as part of (fee / 10000)
feeGrowthGlobalAX64 | number | Global accumulated fee for token A
feeGrowthGlobalBX64 | number | Global accumulated fee for token B
feeProtocol | number | Protocol fee percent
liquidity | number | Pool liquidity amount
maxLiquidityPerTick | number | Pool max liquidity ber one tick
protocolFeeA | asset | Protocol earned fees
protocolFeeB | asset | Protocol earned fees
sqrtPriceX64 | number | Pool price as sqrtPriceX64
tick | number | Pool current tick
tickSpacing | number | Pool tick spacing
tokenA | object | Token A
tokenB | object | Token B
volumeA24 | number | 24H volume of token A
volumeAWeek | number | 7D volume of token A
volumeAMonth | number | 30D volume of token A
volumeB24 | number | 24H volume of token B
volumeBWeek | number | 7D volume of token B
volumeBMonth | number | 30D volume of token B
volumeUSD24 | number | USD Volume for 24H
volumeUSDWeek | number | USD Volume for 7D
volumeUSDMonth | number | USD Volume for 30D
tvlUSD | number | Total Value Locked in USD
change24 | number | 24H price change
changeWeek | number | 7D price change
high24 | number | 24H price high
low24 | number | 24H price low
priceA | number | token A price in terms of token B
priceB | number | token B price in terms of token A


## Pool Positions
```shell
curl https://wax.alcor.exchange/api/v2/swap/pools/0/positions
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 0,
    "owner": ".11dm.wam",
    "tickLower": -443580,
    "tickUpper": 443580,
    "liquidity": 843101,
    "feeGrowthInsideALastX64": "0",
    "feeGrowthInsideBLastX64": "0",
    "feesA": 0,
    "feesB": 0,
    "pool": 0,
    "amountA": "1.6781 TLM",
    "amountB": "0.42356913 WAX"
  },
  ...
]
```

API for getting all positions of pool

### HTTP Request
`GET https://wax.alcor.exchange/api/v2/swap/pools/<:pool_id>/positions`


**Query params:**

Pool id should be provided inside the URL structure

Name | Type | Description | required
--- | --- | --- | ---
pool_id | number | Pool ID | true

### Responce
Name | Type | Description
--- | --- | --- | ---
id | number | position id
owner | string | position owner account
tickLower | number | lower tick of position
tickUpper | number | upper tick of position
liquidity | number | position liquidity amount
feeGrowthInsideALastX64 | number | token A fees grow value
feeGrowthInsideBLastX64 | number | token B fees grow value
feesA | number | token A accumulated fees
feesB | number | token B accumulated fees
pool | number | pool ID
amountA | asset | Positoin token A amount
amountB | asset | Positoin token B amount

## Account Positions
```shell
curl https://wax.alcor.exchange/api/v2/account/<account>/positions
```

> The above command returns JSON structured like this:

```json
[
 {
    "id": 13095,
    "owner": "alcordexfund",
    "tickLower": 40140,
    "tickUpper": 65520,
    "liquidity": "1009363631498",
    "feeGrowthInsideALastX64": "0",
    "feeGrowthInsideBLastX64": "0",
    "feesA": "41789.8580 BRWL",
    "feesB": "1873.58385095 WAX",
    "pool": 667,
    "depositedUSDTotal": 9782.8141,
    "closed": false,
    "collectedFees": {
      "tokenA": 0,
      "tokenB": 0,
      "inUSD": 0
    },
    "inRange": false,
    "amountA": "0.0000 BRWL",
    "amountB": "192032.76838783 WAX",
    "totalValue": 7755.19,
    "pNl": -2027.6241
  },
  ...
]
```

API for getting all positions belong to specific account

### HTTP Request
`GET https://wax.alcor.exchange/api/v2/swap/pools/<:pool_id>/positions`


**Query params:**

Pool id should be provided inside the URL structure

Name | Type | Description | required
--- | --- | --- | ---
pool_id | number | Pool ID | true

### Responce
Name | Type | Description
--- | --- | --- | ---
id | number | position id
owner | string | position owner account
tickLower | number | lower tick of position
tickUpper | number | upper tick of position
liquidity | number | position liquidity amount
feeGrowthInsideALastX64 | number | token A fees grow value
feeGrowthInsideBLastX64 | number | token B fees grow value
feesA | number | token A accumulated fees
feesB | number | token B accumulated fees
pool | number | pool ID
amountA | asset | Positoin token A amount
amountB | asset | Positoin token B amount

depositedUSDTotal | number | total USD value deposited to position
closed | number | is position closed
collectedFees | object | Fees collected by position
inRange | Boolean | is position in range
totalValue | number | Total position value in USD
pNl | number | Profit & Loss (totalValue - depositedUSDTotal)

## Output & Route calculation
```shell
curl "https://alcor.exchange/api/v2/swapRouter/getRoute?trade_type=EXACT_INPUT&input=wax-eosio.token&output=tlm-alien.worlds&amount=1.00000000&slippage=0.30&receiver=alcordexfund&maxHops=2"
```

> The above command returns JSON structured like this:

```json
{
    "executionPrice": {
        "denominator": "100000000",
        "numerator": "39285"
    },
    "input": "1.00000000",
    "maxSent": "1.00000000",
    "memo": "swapexactin#0#alcordexfund#3.9167 TLM@alien.worlds#0",
    "minReceived": "3.9167",
    "output": "3.9285",
    "priceImpact": "0.3",
    "route": [
        0
    ]
}
```

Finding the best route for given input/output

To calculate output amount based on input amount use trade_type <b>EXACT_INPUT</b>
To calculate input amount based on output amount use trade_type <b>EXACT_OUTPUT</b>

<aside class="notice">
EXACT_OUTPUT Will charge + 0.3% more imput amount for slippage, and will refund it within swap transaction.
</aside>


### HTTP Request

`GET https://alcor.exchange/api/v2/swapRouter/getRoute`

**Query params:**

Name | Type | Description | required
--- | --- | --- | ---
trade_type | string | EXACT_OUTPUT or EXACT_INPUT | true
input | string | Input token ID | true
output | string | Output token ID | true
amount | number | Amount of input/output(depends on trade_type) | true
slippage | number | permissible slippage | false
receiver | string | Account to receive output | false
maxHops | number | Maximum number of intermediate pools for exchange route | false

### Responce
Name | Type | Description
--- | --- | --- | ---
executionPrice | object | Execution price in format for Price object from Swap-SDK.
input | number | Input Amount
output | number | Output Amount
maxSent | number | Amount(with slippage included) to get exact output
memo | string | Memo for the transfer action
minReceived | number | Amount to receive with max slippage
priceImpact | number | Swap price impact percent
route | array[number] | Sequence of the pools id's that swap will use

# OnChain Data
To fetch data (orders/markets) directly from blockchain you have to use NodeAPI

Contract tables structute can be found here [https://docs.alcor.exchange](https://docs.alcor.exchange/developers-api/contract-tables)

## Markets
```shell
cleos -u https://wax.greymass.com get table alcordexmain alcordexmain markets
```

```javascript
import fetch from 'node-fetch'
import { Api, JsonRpc, RpcError } from 'eosjs'

const rpc = new JsonRpc('https://wax.greymass.com', { fetch })

// Get markets
const { rows } = await rpc.get_table_rows({
  code: 'alcordexmain', // dex account
  table: 'buyorder', // side
  limit: 1000,
  scope: 'alcordexmain', // scope same as contract name
})
```

> The above command returns JSON structured like this:

```json
{
  "rows": [{
      "id": 0,
      "base_token": {
        "sym": "8,WAX",
        "contract": "eosio.token"
      },
      "quote_token": {
        "sym": "4,PGL",
        "contract": "prospectorsw"
      },
      "min_buy": "0.00000100 WAX",
      "min_sell": "0.0001 PGL",
      "frozen": 0,
      "fee": 0
    }, ...]
}
```
Markets are stored in **markets** table, scoped by contract name.

<aside class="notice">
<b>ATTENTION!</b> <br> Due the legacy codebase of dex smart contract, the naming of <b>base</b> and <b>quote</b> are mixed up in places.
So in the market table on dex contract, the <b>base_token</b> is actually <b>quote_token</b> and vice versa.
</aside>

**market_id** are used as scope for orders table and should be provided as parameter for canceling order.

### Table structute
key | description
---- | -----
id | market_id
base_token | target currency
quote_token | base_token currency
min_buy |  Min buy amount
min_sell | Min sell amount
frozen | Market are frozen if 1
fee | Market fee

## Orders
```shell
cleos -u https://wax.greymass.com get table alcordexmain 26 buyorder -l 2
```

```javascript
import fetch from 'node-fetch'
import { Api, JsonRpc, RpcError } from 'eosjs'

const rpc = new JsonRpc('https://wax.greymass.com', { fetch })

// Get buy orderbook from conract table

const { rows } = await rpc.get_table_rows({
  code: 'alcordexmain',
  table: 'buyorder',
  limit: 1000, // limit up to 1000
  scope: 26, // Market id from /api/markets or markets table
  key_type: 'i128', // we are using it for getting order sorted by price.
  index_position: 2
})
```
> The above command returns JSON structured like this:


```json
{
  "rows": [{
      "id": 28,
      "account": "pxawpxawpxaw",
      "bid": "10.00000000 WAX",
      "ask": "1999.9560 TLM",
      "unit_price": "500012",
      "timestamp": 1603653505
    },{
      "id": 276,
      "account": "e43am.waa",
      "bid": "35.00000000 WAX",
      "ask": "5000.0000 TLM",
      "unit_price": "700000",
      "timestamp": 1609173873
    }
  ],
  "more": true,
  "next_key": "558"
}
```

Orders are stored in **buyorder** and **sellorder** tables.
Scoped by market_id(you can find one in **markets** table)

### Table structute
key | description
---- | -----
id | order id
account | order owner account
unit_price | Price in integer
timestamp | Order time creation

# WebSocket
```javascript
import { io } from 'socket.io-client'

const socket = io('https://alcor.exchange')
```
Alcor using [Socket.IO](https://socket.io/) for interact via WebSocket technology.

**There are two commands for subscribing to and channel with specific information.**

* **subscribe**: Subscribing for an specific room.
* **unsubscribe**: Unsubscribe from sprcific room.

**You can subscribe to rooms to receive specific event information.**

* deals
* ticker
* account
* orderbook

## Deals
```javascript
// Subscribe to deals
socket.emit('subscribe', {
    room: 'deals',
    params: {
        chain: 'wax', // Chain
        market: 26 // Market id
    }
})

// Handle new deals
socket.on('new_deals', deals => { ... })

// Unsubscribe from deals (will unsubscribe from all markets)
socket.emit('unsubscribe', { room: 'deals', params: { chain: 'wax' } })
```

> Responce:

```json
[
    {
      "time": 1674820074000,
      "ask": 3.5771,
      "bid": 0.99799129,
      "type": "buymatch",
      "unit_price": 0.27899985,
      "trx_id": "d4acaa5ae75bccad12ca82dd2d1d3fa5822cece1307ced10ee0daefaeb6d5009"
    }
]
```

Subscribing to new deals for specific market.

**Room name**: deals

**Params**:

Key | Value
--- | ---
chain | chain id
market | market id

## Orderbook
```javascript
// Subscribe to buy orderbook of 26 (TLM on wax) market.
socket.emit('subscribe', {
    room: 'deals',
    params: {
        chain: 'orderbook', // Chain
        market: 26, // Market id,
        side: 'buy'
    }
})

// On orderbook bid side update
socket.on('orderbook_buy', bids => { ... })

// On orderbook ask side update
socket.on('orderbook_sell', asks => { ... })

// Unsubscribe from orderbook (all, buy and sell)
socket.emit('unsubscribe', { room: 'orderbook', params: { chain: 'wax', market: 26 } })
```

> Responce:

```json
[
    [
      27899985,
      3044158,
      8493196253
    ]
]
```

Subscribe to orderbook updates. First update is full order book state.

**Room name**: orderbook

**Params**:

Key | Value
--- | ---
chain | chain id
market | market id
side | **sell** or **buy**

## Ticker
```javascript
// Subscribe
socket.emit('subscribe', {
  room: 'ticker',
  params: {
    chain: 'wax',
    market: 26,
    resolution: '30'
  }
})

// Unsubscribe
socket.emit('unsubscribe', {
  room: 'ticker',
  params: {
    chain: 'wax',
    market: 26,
    resolution: '30'
  }
})

```

> Responce:

```json
[
  "tick",
  {
    "close": 0.01175084,
    "open": 0.01175084,
    "high": 0.01175084,
    "low": 0.01175084,
    "volume": 0.11727339,
    "time": 1674821301500
  }
]
```

Subscribe for chart updates.

**Room name**: ticker

**Params**:

Key | Value
--- | ---
chain | chain id
market | market id
resolution | Resolution (see list below)

Supported resolutions:

`1, 5, 15, 30, 60, 240, 1D, 1W, 1M`

## Account
```javascript
socket.emit('subscribe', {
    room: 'account', params: {
        chain: 'wax',
        'name': 'randomuser' // Account for listen events
    }
})
```

> Responce

```json
[
  "match",
  {
    "ask": 0.11727339,
    "market_id": 156,
    "price": 0.01175084
  }
]
```

Subscribe to account events/notifications. Only order matches for now.

**Room name**: account

**Params**:

Key | Value
--- | ---
chain | chain id
name | Account

# Trade API
To trade assets you sould use Blockchain API directly. More information on Interaction/NodeAPI.

## Place order
```shell
cleos push action tktoken transfer \
    '[bob, alcordexmain, "0.5000 TKT", "0.0010 EOS@eosio.token"]' -p bob
```
```javascript
const actions = [{
  account: 'tktoken', // token contract
  name: 'transfer',
  authorization: [{
    actor: 'useraaaaaaaa', // account placing order (owner)
    permission: 'active',
  }],
  data: {
    from: 'useraaaaaaaa',
    to: 'alcordexmain',
    quantity: '0.5000 TKT', // Bid
    memo: '0.0001 EOS@eosio.token' // Ask
  }
}]

// Result of transaction
const r = await api.transact(actions)
```

> Bob are selling 0.5 TKT and buying 0.001 EOS.


Send the amount(bid) you want to sell to dex contract account, and specify the amount you ask in the memo, the price and market will be automatically determined in the contract.

Memo format(ask token):
`<token_amount> <token_symbol>@<token_contract>`

<aside class="notice">
    Orders can not be updated. To update order simply cancel current and place new one.
</aside>

### Place multiple orders
Same way as described but transaction may contain multiple actions(array).

## Cancel order
```shell
cleos push action alcordexmain cancelsell \
    '[bob, 262, 1284277]' -p bob
```
```javascript
const result = await api.transact([
    {
        account: 'tktoken',
        name: 'transfer',
        authorization: [{
          actor: 'useraccountname',
          permission: 'active',
        }],
        data: {
          from: 'useraccountname',
          to: 'alcordexmain',
          quantity: '0.5000 TKT',
          memo: '0.0010 EOS@eosio.token'
        }
    }
]);
```

> Bob are canceling sell order on 262 market.

Call action **cancelsell** or **cancelbuy** with parameters:

* **executor** - order owner account name
* **market_id** - id of the order related market
* **order_id** - order id.
