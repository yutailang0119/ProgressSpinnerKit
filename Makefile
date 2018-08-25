demo:
	swift run Demo

test:
	swift test

generate_xcodeproj:
	swift package generate-xcodeproj

clean:
	swift package clean

.PHONY: demo test generate_xcodeproj clean
