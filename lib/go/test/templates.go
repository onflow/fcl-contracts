package test

import (
	"regexp"

	"github.com/onflow/flow-go-sdk"
)

type Contracts struct {
	FCLCrypto flow.Address
}

var fclCryptoPlaceholder = regexp.MustCompile(`"[^"\s].*/FCLCrypto.cdc"`)

const (
	fclCryptoPath                    = "../../../contracts/FCLCrypto.cdc"
	scriptsRootPath                  = "../../../scripts"
	verifyUserSignaturesPath         = scriptsRootPath + "/verifyUserSignatures.cdc"
	verifyAccountProofSignaturesPath = scriptsRootPath + "/verifyAccountProofSignatures.cdc"
)

func replaceAddresses(codeBytes []byte, contracts Contracts) []byte {
	code := string(codeBytes)

	code = fclCryptoPlaceholder.ReplaceAllString(code, "0x"+contracts.FCLCrypto.String())

	return []byte(code)
}

func fclCryptoContract() []byte {
	return readFile(fclCryptoPath)
}

func verifyUserSignaturesScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(verifyUserSignaturesPath),
		contracts,
	)
}

func verifyAccountProofSignaturesScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(verifyAccountProofSignaturesPath),
		contracts,
	)
}
