---
title: Alcor API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

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
Welcome to the Alcor API here you can find all the necessary information on interacting with Alcor.

Interaction with Alcor is divided into 2 types:

* **Interaction with the contract.**
    * Place/Cancel order.
    * Add/Remove LP position.
* **Obtaining information about the markets using the Alcor API services.**
    * Market Data
    * Liquidity pools Data
    * WebSocket Stream

## Alcor API
Alcor Exchange has HTTP and WebSocket api. Which can get information on various markets, orderboos, prices, events, and charts.
WebSocket allows streaming for orderbook updates, new deals, and account events.

<aside class="notice">
    Alcor API can be used only for retrieve data. For interacting with blockchain(place/cancel order) use NODE API.
</aside>

## Node API
Alcor is DEX, so, intereations with exchange, such as placing new order or order cancel, requires work with <b>blockchain node api directly</b>. Some examples can be found in **Trading API** section.


# Market Data
Alcor Exchange has HTTP and WebSocket api. Which can get information on various markets, orderboos, prices, events, and charts.
WebSocket allows streaming for orderbook updates, new deals, and account events.

Token symbol repesented as <b>SYMBOL_contract</b>
following the eosio.token standard. As the one symbol can be deployed by multiple contracts.

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

## Get Trading pairs
Provides a list of all trading pairs on the Alcor DEX.

```shell
curl "https://alcor.exchange/api/v2/pairs"
```

> The above command returns JSON structured like this:

```json
{
    "base": {
        "contract": "prospectorsw",
        "precision": 4,
        "symbol": "PGL"
    },
    "target": {
        "contract": "eosio.token",
        "precision": 8,
        "symbol": "WAX"
    },
    "ticker_id": "PGL-prospectorsw_WAX-eosio.token"
}
```

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker with delimiter to separate base/target
base | string | Symbol code of a the base cryptoasset PIXEL
target | string | Symbol code of the target cryptoasset WAX

### HTTP Request

`GET https://alcor.exchange/api/v2/pairs`

## Get Ticker
TODO

## Get Tickers
Endpoint provides pricing and volume information on each market pair available on an exchange.

Ticker ID represented as base token (Symbol-contract) _ quote_token (Symbol-contract)
example: <b>RDA-deadcitytokn_WAX-eosio.token</b>

```shell
curl "https://alcor.exchange/api/v2/tickers"
```
> The above command returns JSON structured like this:

```json
[
    {
        "market_id": 656,
        "ticker_id": "WNG-waxpnftgames_WAX-eosio.token",
        "base_currency": "WNG-waxpnftgames",
        "target_currency": "WAX-eosio.token",
        "last_price": 0.0002,
        "base_volume": 332,
        "target_volume": 12,
        "bid": 0.0002505,
        "ask": 0.099,
        "high24": 0.0002,
        "low24": 0.0002,
        "change24": 0,
        "fee": 0,
        "frozen": false,
        "min_buy": "1.00000000 WAX",
        "min_sell": "0.00000001 WNG",
        "quote_volume": 0,
        "volume24": 0,
        "volumeMonth": 1600.234234,
        "volumeWeek": 40.24999686
    }
]
```


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
ticker_id | string | Identifier of a ticker with delimiter to separate base/target
base | string | Symbol code of a the base cryptoasset PIXEL
target | string | Symbol code of the target cryptoasset WAX


## Get Orderbook
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







## Get Latest Trades
Retrieve the most recent deals of a ticker, sorted by time from latest to oldest.

```shell
curl "https://alcor.exchange/api/v2/tickers/:ticker_id/latest_trades"
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

`GET https://alcor.exchange/api/v2/:ticker_id/latest_trades`

### Query Parameters

Parameter | Mandatory | Default | Description
--------- | ------- | ----------- | --
limit | false | 300 | The number of latest trades to return


## Get Trade history
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

`GET https://alcor.exchange/api/v2/:ticker_id/historical_trades`

Sorting from lasted to oldest deals

### Query Parameters

Parameter | Type | Description
--------- | ------- | -----------
type | string | Filter by "sell" or "buy" trades
limit | integer | Number of trades to retrieve
step | integer | Offset, can be changed for step-by-step loading of the entire history
start_time | timestamp | Start time from which to query trades
end_time | timestamp | End time for historical trades

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
trade_id | string | A unique ID associated with the trade for the currency pair transaction
price | decimal | Transaction price.
base_volume | decimal | Transaction amount in base pair volume
target_volume | decimal | Transaction amount in target pair volume.
time | timestamp | Unix timestamp in milliseconds for when the transaction occurred.
type | string |  Used to determine the type of the transaction that was completed.

## Get Klines (Candles)
This endpoint retrieves klines for specific ticker in a specific range.

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
    },
    {
        "close": 0.5889,
        "high": 0.589,
        "low": 0.553,
        "open": 0.5889,
        "time": 1637863204500,
        "volume": 32.12719794
    },
    {
        "close": 0.59,
        "high": 0.589,
        "low": 0.55999979,
        "open": 0.5889,
        "time": 1637866965000,
        "volume": 1759.5935863099999
    }
]
]
```

### HTTP Request

`GET https://alcor.exchange/api/v2/tickers/:ticker_id/orderbook`


### Query Parameters

from, to, resolution, limit

Parameter | Mandatory | Type | Description
--------- | ------- | ----------- | ---------
ticker_id | true | string | Ticker id
resolution | true | string | Resolution
from | false | timestamp | Start time for getting historical candles
to | false | timestamp | End time till which query candles

**Resolutions**

Value | Description
----- | ----------
1 | 1 min
5 | 5 min
15 | 15 min
30 | 30 min
60 | one hour
240 | 4 hours
1D | one day
1W | one week
1M | one month

## Get pools (Swap page)
TODO


## Get Pool charts
TOD

# WebSocket

# Trade API
Alcor support multiple EOSIO blockchains. Here is contract accounts across supported cahins:

- WAX - alcordexmain
- EOS - eostokensdex
- TELOS - eostokensdex
- Proton - alcor

You can easly interacting with alcor contracts using **[EOSJS library](https://github.com/EOSIO/eosjs)**. 

<aside class="notice">
<b>ATTENTION!</b> Due the legacy codebase of dex smart contract, the <b>base</b> and <b>quote</b> are mixed up in places.
So in the market table on dex contract, the <b>base_token</b> is actually <b>quote_token</b> and vice versa.
</aside>


## Place order
TODO

## Place multiple orders

## Cancel order
