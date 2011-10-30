def writeLog (entryType, entryClass, entryMessage, entryLocation)
	logFile = File.new($logFileCompletePath, "a")
	logFile.puts "#{Time.now.asctime}, Type: #{entryType} Class: #{entryClass}, Message: #{entryMessage}, Location: #{entryLocation}"
	logFile.close
end
