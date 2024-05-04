package internal

import (
	"fmt"
	"strconv"
)

func HumanStorage2Bytes(value string) (int, error) {
	unitSuffix := value[len(value)-1:]
	numericValue, err := strconv.ParseInt(value[:len(value)-1], 10, 64)
	if err != nil {
		return 0, err
	}

	var multiplier int
	switch unitSuffix {
	case "K":
		multiplier = 1 << 10
	case "M":
		multiplier = 1 << 20
	case "G":
		multiplier = 1 << 30
	default:
		return 0, fmt.Errorf("unsupported unit suffix: %s", unitSuffix)
	}

	return int(numericValue) * multiplier, nil
}
