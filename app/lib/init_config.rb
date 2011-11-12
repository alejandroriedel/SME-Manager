def setLogFileCompleteName (path)
	$logFileCompletePath = Time.now.strftime("#{path}#{CURRENT_DATE}.log")
	if($logFileCompletePath == nil || $logFileCompletePath == "")
		writeLog(LBL_ERROR, RuntimeError, ERR_LOG_FILE_NAME, ERR_LOC_INICNF_SLFCN)
		raise RuntimeError, ERR_LOG_FILE_NAME, ERR_LOC_INICNF_SLFCN
	end
end

def getDBCompleteName (path,name)
	db = path + name
	if (db == nil || db == "")
		writeLog(LBL_ERROR, RuntimeError, ERR_DB_FILE_NAME, ERR_LOC_INICNF_GDBCN)
		raise RuntimeError, ERR_DB_FILE_NAME, ERR_LOC_INICNF_GDBCN
	else
		return db
	end
end

def backupDB
	allFiles = Dir.entries(DB_PATH)
	bkFiles = Array.new
	allFiles.each_index do |index|
		bkFiles.push(allFiles[index].gsub('.bk','')) if allFiles[index].include?(".bk")
	end
	dbBackupName = "#{DB_PATH}#{CURRENT_DATE}_#{DB_NAME.gsub('.db','_db.bk')}"
	if bkFiles.length == 0
		RUBY_VERSION < '1.9' ? File.copy "#{DB_PATH}#{DB_NAME}", dbBackupName : FileUtils.cp "#{DB_PATH}#{DB_NAME}", dbBackupName
	else
		lastLogDate = Date.strptime("#{bkFiles.sort[bkFiles.length-1].split("_")[0]}", "%Y-%m-%d")
		if (lastLogDate + (DB_BK_DAYS) <=> Date.strptime(CURRENT_DATE, "%Y-%m-%d")) == -1
			RUBY_VERSION < '1.9' ? File.copy "#{DB_PATH}#{DB_NAME}", dbBackupName : FileUtils.cp "#{DB_PATH}#{DB_NAME}", dbBackupName
		end
	end
end
