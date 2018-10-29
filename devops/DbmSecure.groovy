//#--------------#
//#  Encrypt/Decrypt
import static java.nio.charset.StandardCharsets.UTF_8

class DbmSecure {

	def salt() {
		return("sakjkj509gkj31jkb0#kfkf397")
	}

	def encrypt(arg_map) {
		println("Encrypting")
		def stg = arg_map["password"]
		println("Start: ${stg}")
		def mix = "${salt()}${stg}".reverse()
		//def working = mix.reverse().getBytes(UTF_8)
		def result = mix.bytes.encodeBase64().toString()
		println("Finish: ${result}")
		return(result)
	}

	def decrypt(arg_map) {
		println("Decrypting")
		def stg = arg_map["password"]
		println("Start: ${stg}")
		def res = new String(stg.decodeBase64())
		def mix = res.reverse()
		def result = mix.replaceAll(salt(), "")
		println("Finish: ${result}")
		return(result)
	}

	def freerun(){
		arg_map = [:]
		for (arg in this.args) {
		  //println arg
		  pair = arg.split("=")
		  if(pair.size() == 2) {
			arg_map[pair[0].trim()] = pair[1].trim()
		  }else{
			arg_map[arg] = ""
		  }
		}
		println("#### Password Masking ####")
		if( arg_map["action"] == "encrypt") {
			println("Encrypting")
			println("Start: ${arg_map["password"]}")
			def res = encrypt(arg_map["password"])
			println("Finish: ${res}")
		}
		if( arg_map["action"] == "decrypt") {
			println("Decrypting")
			println("Start: ${arg_map["password"]}")
			def res = decrypt(arg_map["password"])
			println("Finish: ${res}")
		}
	}

}