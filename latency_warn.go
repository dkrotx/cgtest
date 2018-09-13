package main

import (
	"fmt"
	"time"
)

func main() {
	const reportPeriodMs = 50
	const minLatencyPeriod = 20 // will print warns if awaiting time exceeded
	lastTime := time.Now()

	for {
		now := time.Now()
		msPassed := now.Sub(lastTime) / time.Millisecond
		if msPassed >= reportPeriodMs {
			fmt.Printf("%d ms since last call", msPassed)
			if msPassed >= reportPeriodMs + minLatencyPeriod {
				fmt.Print("  <<<<<<< TOOK TOO LONG")
			}
			fmt.Println("")
			lastTime = now
		}
	}
}
