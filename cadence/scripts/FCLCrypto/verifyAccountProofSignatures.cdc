import FCLCrypto from "../../contracts/FCLCrypto.cdc"

access(all) fun main(
    address: Address,
    message: String,
    keyIndices: [Int],
    signatures: [String]
): Bool {
    return FCLCrypto.verifyAccountProofSignatures(
        address: address,
        message: message,
        keyIndices: keyIndices,
        signatures: signatures
    )
}
