import Foundation

public class NetworkConfig {
  public static let shared = NetworkConfig()

  private init() {}

//  public var baseURL = Constants.Network.baseURL
  public var baseURL = "https://events-au-v2.vercel.app/"
}

