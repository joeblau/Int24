//
//  main.swift
//  Int24
//
//  Created by Joe Blau on 2/9/22.
//

import Foundation
import web3
import os.log

// MARK: - OS Log
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let uniswapSmartContract = OSLog(subsystem: subsystem, category: "uniswap_smart_contract")
}

// MARK: - Constants
// https://etherscan.io/address/0x69d91b94f0aaf8e8a2586909fa77a5c2c89818d5/advanced#readContract
let HEX_USDC_UNISWAP_V3_POOL_ADDRESS = EthereumAddress("0x69d91b94f0aaf8e8a2586909fa77a5c2c89818d5")
let INFURA_CLIENT = EthereumClient(url: URL(string: "https://mainnet.infura.io/v3/84842078b09946638c03157f83405213")!)

// MARK: - Slot0 Function
let slot0 = Slot0ABIFunction(contract: HEX_USDC_UNISWAP_V3_POOL_ADDRESS)
slot0.call(withClient: INFURA_CLIENT,
           responseType: Slot0ABIFunction.Response.self) { error, response in
    switch error {
    case let .some(err):
        os_log("%@", log: .uniswapSmartContract, type: .error, err.localizedDescription)
    case .none:
        switch response {
        case let .some(response):
            print(HEX_USDC_UNISWAP_V3_POOL_ADDRESS, response.tick)
        case .none:
            os_log("No slot in pool", log: .uniswapSmartContract, type: .info)
        }
    }
}

// Sleep for 3 seconds and check the logs
RunLoop.main.run(until: Date(timeIntervalSinceNow: 3))
