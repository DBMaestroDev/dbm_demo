import groovy.json.JsonSlurper

def delphix_url = "172.31.79.14"
urlString = "http://${delphix_url}/resources/json/delphix"
cookies = []

build_session()
// List Databases
def answer = rest_get("database")
print_result(answer)

def build_session(){
	def result = [:]
	def login_params = "{\"type\":\"LoginRequest\",\n"
	login_params += "\"username\":\"delphix_admin\",\n"
	login_params += "\"password\":\"delphix\"\n}"

	def api_params = "{\"type\": \"APISession\",\n"
	api_params += "\"version\": {\n"
	api_params += "\"type\": \"APIVersion\",\n"
	api_params += "\"major\": 1,\n"
	api_params += "\"minor\": 7,\n"
	api_params += "\"micro\": 0}\n"
	api_params += "}"
	def answer = rest_post("session", api_params, true)
	print_result(answer)
	println "API Params"
	println api_params
	
	separator()
	println "Login Session"
	//println login_params
	answer = rest_post("login", login_params)
	print_result(answer)
}

def rest_get(url_frag, verbose = true) {
	separator()
	result = [:]
	url = "${urlString}/${url_frag}".toURL()
	result["url"] = url
	con = (HttpURLConnection) url.openConnection();
	for (cookie in cookies){
		con.addRequestProperty("Cookie", cookie.split(";", 2)[0])
	}
	con.setUseCaches(true)
	con.setDoOutput(true)
	//con.setDoInput(true)
	con.setRequestProperty("Content-Type", "application/json")
	result["result"] = con.getResponseCode()
	result["response"] = con.getInputStream().getText()
	return result
}

def rest_post(url_frag, params, set_cookie = false) {
	separator()
	result = [:]
	url = "${urlString}/${url_frag}".toURL()
	result["url"] = url
	con = (HttpURLConnection) url.openConnection()
	if(!set_cookie){
		for (cookie in cookies){
			con.addRequestProperty("Cookie", cookie.split(";", 2)[0])
		}
	}
	con.setUseCaches(true)
	con.setDoOutput(true)
	con.setDoInput(true)
	con.setRequestProperty("Content-Type", "application/json")
	con.outputStream.withWriter { writer ->
	  writer << params
	}
	if(set_cookie){
		cookies = con.getHeaderFields().get("Set-Cookie")
	}
	result["result"] = con.getResponseCode()
	result["response"] = con.getInputStream().getText()
	return result
}

def print_result(result){
	message_box("Rest Result")
	println "-  URL: ${result["url"]}"
	println "-  Result: ${result["result"]}"
	println "-  Response: ${result["response"]}"
}

def getall_headers(){
	if (false && con.getResponseCode() == HttpURLConnection.HTTP_OK){
		Map<String, List<String>> map = con.getHeaderFields();
		System.out.println("Printing Response Header...\n");
		for (Map.Entry<String, List<String>> entry : map.entrySet()){
			System.out.println("Key : " + entry.getKey() + " ,Value : " + entry.getValue());
		}
	}
}

def message_box(msg, def mtype = "sep") {
  def tot = 80
  def start = ""
  def res = ""
  msg = (msg.size() > 65) ? msg[0..64] : msg
  def ilen = tot - msg.size()
  if (mtype == "sep"){
    start = "#${"-" * (ilen/2).toInteger()} ${msg} "
    res = "${start}${"-" * (tot - start.size() + 1)}#"
  }else{
    res = "#${"-" * tot}#\n"
    start = "#${" " * (ilen/2).toInteger()} ${msg} "
    res += "${start}${" " * (tot - start.size() + 1)}#\n"
    res += "#${"-" * tot}#\n"
  }
  println res
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  println "#${dashy}#"
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
