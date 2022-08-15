package test

import (
	"regexp"

	"github.com/onflow/flow-go-sdk"
)

type Contracts struct {
	FCLCrypto flow.Address
	FlowInteractionTemplateAudit flow.Address
}

var fclCryptoPlaceholder = regexp.MustCompile(`"[^"\s].*/FCLCrypto.cdc"`)
var flowInteractionTemplatePlaceholder = regexp.MustCompile(`"[^"\s].*/FlowInteractionTemplateAudit.cdc"`)

const (
	fclCryptoPath                    = "../../../contracts/FCLCrypto.cdc"
	scriptsRootPath                  = "../../../scripts"
	flowInteractionTemplatePath			 = "../../../contracts/FlowInteractionTemplateAudit.cdc"
	verifyUserSignaturesPath         = scriptsRootPath + "/FCLCrypto/verifyUserSignatures.cdc"
	verifyAccountProofSignaturesPath = scriptsRootPath + "/FCLCrypto/verifyAccountProofSignatures.cdc"
)

func replaceAddresses(codeBytes []byte, contracts Contracts) []byte {
	code := string(codeBytes)

	code = fclCryptoPlaceholder.ReplaceAllString(code, "0x"+contracts.FCLCrypto.String())

	return []byte(code)
}

func fclCryptoContract() []byte {
	return readFile(fclCryptoPath)
}

func flowInteractionTemplateContract() []byte {
	return readFile(flowInteractionTemplatePath)
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
