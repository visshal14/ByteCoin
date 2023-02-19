//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Vishal Pal 


import Foundation

protocol CoinManagerDelegate{
    func didFailWithError(error:Error)
    func didUpdatePrice(price:String,currency:String)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "77A99DAD-161F-4994-AA75-EA77F9C8D931"
    
//    https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=77A99DAD-161F-4994-AA75-EA77F9C8D931
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency :String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data,response,error) in
                if error != nil{
                   print(error!)
                    return
                }
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format:"%.2f",bitcoinPrice)
                        self.delegate?.didUpdatePrice(price:priceString,currency: currency)
                    }
                    
                }
                
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data:Data)->Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self,from:data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
