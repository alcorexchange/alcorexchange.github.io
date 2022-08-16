---
title: Alcor API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

<!---

includes:
  - errors
-->

search: true

code_clipboard: true

meta:
  - name: description
    content: Alcor Exchange API documentation
---

# Introduction
Welcome to the Alcor API here you can find all the necessary information on interacting with Alcor.

<b>Interaction with Alcor is divided into 2 types.</b>

- Interaction with the contract. **(Node API)**
- Obtaining information about the markets using the Bakend API services. **(Bakend API)**

# Backend API
Alcor Exchange has HTTP and WebSocket api. Which can get information on various markets, orderboos, prices, events, and charts.
WebSocket allows streaming for orderbook updates, new deals, and account events.

#### URL Structure
HTTP API URL are separated by chains using following structute.
The UI are following same structute as api, they are splitted by subdomains named by chain.

Chain | URL
---------- | -------
WAX | <b>https://alcor.exchange/api/v2/</b>
EOS | <b>https://eos.alcor.exchange/api/v2/</b>
Proton | <b>https://proton.alcor.exchange/api/v2/</b>
Telos | <b>https://telos.alcor.exchange/api/v2/</b>


<aside class="notice">
All timestamp's are expected to be in milliseconds
</aside>

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
        "last_price": 0.604955,
        "ask": 0.66299999,
        "bid": 0.64800031,
        "high": 0.604960,
        "low": 0.604950,
        "base_volume": 20351,
        "target_volume": 12312,
        "base_currency": "PGL-prospectorsw",
        "target_currency": "WAX-eosio.token",
        "ticker_id": "PGL-prospectorsw_WAX-eosio.token"
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


## Get Trading pairs
Provides a list of all trading pairs on the Alcor DEX.

```shell
curl "https://alcor.exchange/api/v2/pairs"
```

> The above command returns JSON structured like this:

```json
[
    {
        "ticker_id": "ZBW-zombiecointk_WAX-eosio.token",
        "base": "ZBW-zombiecointk",
        "target": "WAX-eosio.token"
    },
    {
        "ticker_id": "PIXEL-penguincoins_WAX-eosio.token",
        "base": "PIXEL-penguincoins",
        "target": "WAX-eosio.token"
    }
]
```

Token symbol repesented as <b>SYMBOL_contract</b>
following the eosio.token standard. As the one symbol can be deployed by multiple contracts.

### Responce
Name | Type | Description
---------- | --------------------------- | ----------- | -----------
ticker_id | string | Identifier of a ticker with delimiter to separate base/target
base | string | Symbol code of a the base cryptoasset PIXEL
target | string | Symbol code of the target cryptoasset WAX

### HTTP Request

`GET https://alcor.exchange/api/v2/pairs`

## Get Orderbook
```shell
curl "http://alcor.exchange/api/v2/orderbook/pgl-prospectorsw_wax-eosio.token?depth=10"
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

Endpoint using to provide order book information with at least depth = 100 returned for a given ticker. 

### HTTP Request

`GET http://alcor.exchange/api/v2/orderbook/:ticker_id`

### Query Parameters

Parameter | Mandatory | Default | Description
--------- | ------- | ----------- | --
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
curl "http://alcor.exchange/api/v2/tickers/:ticker_id/latest_trades"
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

### HTTP Request

`GET http://alcor.exchange/api/v2/orderbook/:ticker_id`

### Query Parameters

Parameter | Mandatory | Default | Description
--------- | ------- | ----------- | --
limit | false | 300 | The number of latest trades to return


## Get Trade history
Retrieve the recent transactions of an instrument, sorted by time from earlyer to latest.

```shell
curl "http://alcor.exchange/api/v2/historical_trades/pgl-prospectorsw_wax-eosio.token?limit=2"
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

`GET http://alcor.exchange/api/v2/historical_trades/:ticker_id`

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
curl "https://alcor.exchange/api/v2/:ticker_id/charts"
```

> The above command returns JSON structured like this:

```json
[
    {
        "volume":2170.14554774,
        "open":0.06173,
        "high":0.062,
        "low":0.06125091,
        "close":0.06125091,
        "time":1659803552500
    }

]
```

### Query Parameters

from, to, resolution, limit

Parameter | Mandatory | Type | Description
--------- | ------- | ----------- | ---------
ticker_id | true | string | Ticker id
from | false | timestamp | Start time for getting historical candles
to | false | timestamp | End time till which query candles
limit | false | integer | Limitation of results

## Get pools (Swap page)
TODO


## Get Pool charts
TOD


# Node API
Alcor is DEX, so, intereations with blockchain, such as placing new order or order cancel, requires work with <b>blockchain node api directly</b>. Some examples can be found in "Node API" section.

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
