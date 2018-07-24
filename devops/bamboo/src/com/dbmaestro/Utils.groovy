package src.com.dbmaestro

def message_box(msg, def mtype = "sep") {
    def tot = 100
    def start = ""
    def res = ""
    msg = (msg.size() > 85) ? msg[0..84] : msg
    def ilen = tot - msg.size()
    if (mtype == "sep") {
        start = "#${"-" * (ilen / 2).toInteger()} ${msg} "
        res = "${start}${"-" * (tot - start.size() + 1)}#"
    } else {
        res = "#${"-" * tot}#\r\n"
        start = "#${" " * (ilen / 2).toInteger()} ${msg} "
        res += "${start}${" " * (tot - start.size() + 1)}#\r\n"
        res += "#${"-" * tot}#\r\n"
    }
    println res
    return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  println "#${dashy}#"
}

def password_decrypt(password_enc){
  def slug = "__sj8kl3LM77g903ugbn_KG="
  def result = ""
  byte[] decoded = password_enc.decodeBase64()
  def res = new String(decoded)
  res = res.replaceAll(slug,"")
  result = new String(res.decodeBase64())
  return result
}

def ensure_dir(pth) {
  folder = new File(pth)
  if ( !folder.exists() ) {
  println "Creating folder: ${pth}"
  folder.mkdirs() }
  return pth
}

def dir_exists(pth) {
  folder = new File(pth)
  return folder.exists()
}

def create_file(pth, name, content){
  def fil = new File(pth,name)
  fil.withWriter('utf-8') { writer ->
      writer << content
  }
  return "${pth}${sep}${name}"
}

def read_file(pth, name){
  def fil = new File(pth,name)
  return fil.text
}

def shell_command(cmd) {
	def command = "cmd.exe /c \"${cmd}\""
	def proc = command.execute()
	def sout = new StringBuilder(), serr = new StringBuilder()
	proc.waitForOrKill(5000)
	proc.consumeProcessOutput(sout, serr)
	println "Running: ${command}"
	message_box("RESULTS")
	println sout
	if (serr.length() > 2){
		println "Error: ${serr}"
	}
	return ["command" : command, "stdout" : sout, "stderr" : serr]
}

def sep(){
	"\\"
}