package test

import (
	"encoding/hex"
	"testing"

	"github.com/onflow/cadence"
	jsoncdc "github.com/onflow/cadence/encoding/json"
	emulator "github.com/onflow/flow-emulator"
	"github.com/onflow/flow-go-sdk"
	"github.com/onflow/flow-go-sdk/crypto"
	"github.com/onflow/flow-go-sdk/test"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDeployFCLCryptoContract(t *testing.T) {
	b := newEmulator()
	deployFCLCryptoContract(t, b)
}

type testCase struct {
	name        string
	accountKeys []*flow.AccountKey
	signers     []crypto.Signer
	expected    bool
}

func TestVerifyUserSignatures(t *testing.T) {
	testVerifySignatures(t, verifyUserSignaturesScript)
}

func TestVerifyAccountProofSignatures(t *testing.T) {
	testVerifySignatures(t, verifyAccountProofSignaturesScript)
}

func testVerifySignatures(t *testing.T, getVerifyScript func(Contracts) []byte) {
	b := newEmulator()

	fclCrypto := deployFCLCryptoContract(t, b)

	contracts := Contracts{
		FCLCrypto: fclCrypto,
	}

	verifyScript := getVerifyScript(contracts)

	accountKeys := test.AccountKeyGenerator()

	accountKeyA, signerA := accountKeys.NewWithSigner()
	accountKeyA.SetWeight(1000)

	accountKeyB, signerB := accountKeys.NewWithSigner()
	accountKeyB.SetWeight(100)

	accountKeyC, signerC := accountKeys.NewWithSigner()
	accountKeyC.SetWeight(500)

	accountKeyD, signerD := accountKeys.NewWithSigner()
	accountKeyD.SetWeight(500)

	testCases := []testCase{
		{
			"single key - full weight - valid signature",
			[]*flow.AccountKey{accountKeyA},
			[]crypto.Signer{signerA},
			true,
		},
		{
			"single key - full weight - invalid signature",
			[]*flow.AccountKey{accountKeyA},
			[]crypto.Signer{signerB},
			false,
		},
		{
			"single key - partial weight - valid signature",
			[]*flow.AccountKey{accountKeyB},
			[]crypto.Signer{signerB},
			false,
		},
		{
			"multi key - full weight - valid signatures",
			[]*flow.AccountKey{accountKeyC, accountKeyD},
			[]crypto.Signer{signerC, signerD},
			true,
		},
		{
			"multi key - full weight - invalid signatures",
			[]*flow.AccountKey{accountKeyC, accountKeyD},
			[]crypto.Signer{signerD, signerC},
			false,
		},
		{
			"multi key - partial weight - valid signatures",
			[]*flow.AccountKey{accountKeyB, accountKeyC},
			[]crypto.Signer{signerB, signerC},
			false,
		},
	}

	message, _ := hex.DecodeString("deadbeef")

	for _, testCase := range testCases {
		t.Run(testCase.name, func(t *testing.T) {

			address, err := b.CreateAccount(testCase.accountKeys, nil)
			require.NoError(t, err)

			signatures := make([][]byte, len(testCase.signers))

			for i, signer := range testCase.signers {
				signature, err := flow.SignUserMessage(signer, message)
				require.NoError(t, err)

				signatures[i] = signature
			}

			verified := verifySignatures(
				t, b,
				verifyScript,
				address,
				message,
				testCase.accountKeys,
				signatures,
			)

			assert.Equal(t, testCase.expected, verified)
		})
	}
}

func verifySignatures(
	t *testing.T,
	b *emulator.Blockchain,
	script []byte,
	address flow.Address,
	message []byte,
	accountKeys []*flow.AccountKey,
	signatures [][]byte,
) bool {
	messageHex := hex.EncodeToString(message)

	keyIndicesCadence := make([]cadence.Value, len(accountKeys))

	for i := range accountKeys {
		keyIndicesCadence[i] = cadence.NewInt(i)
	}

	signaturesCadance := make([]cadence.Value, len(signatures))

	for i, signature := range signatures {
		signaturesCadance[i] = cadence.String(hex.EncodeToString(signature))
	}

	result, err := b.ExecuteScript(
		script,
		[][]byte{
			jsoncdc.MustEncode(cadence.Address(address)),
			jsoncdc.MustEncode(cadence.String(messageHex)),
			jsoncdc.MustEncode(cadence.NewArray(keyIndicesCadence)),
			jsoncdc.MustEncode(cadence.NewArray(signaturesCadance)),
		},
	)
	require.NoError(t, err)

	if result.Error != nil {
		return false
	}

	return result.Value.ToGoValue().(bool)
}
