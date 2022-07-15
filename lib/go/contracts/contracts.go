package contracts

import "github.com/onflow/fcl-contracts/lib/go/contracts/internal/assets"

//go:generate go run github.com/kevinburke/go-bindata/go-bindata -prefix ../../../contracts -o internal/assets/assets.go -pkg assets -nometadata -nomemcopy ../../../contracts

const cryptoFilename = "FCLCrypto.cdc"

func FCLCrypto() []byte {
	code := assets.MustAssetString(cryptoFilename)
	return []byte(code)
}
