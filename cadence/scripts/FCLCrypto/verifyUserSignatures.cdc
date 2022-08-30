import FCLCrypto from "./contracts/FCLCrypto.cdc"

pub fun main(
    address: Address,
    message: String,
    keyIndices: [Int],
    signatures: [String]
): Bool {
    return FCLCrypto.verifyUserSignatures(
        address: address,
        message: message,
        keyIndices: keyIndices,
        signatures: signatures
    )
}
