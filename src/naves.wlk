class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method acelerar(cuanto) {
		velocidad = 100000.min(velocidad + cuanto)
		// velocidad = (velocidad + cuanto).min(100000)
	}
	
	method desacelerar(cuanto) {
		velocidad = 0.max(velocidad - cuanto)
		// (velocidad - cuanto).max(0)
	}
	
	method irHaciaElSol() { direccion = 10 }
	method escaparseDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol() { direccion = 10.min(direccion + 1) }
	method alejarseUnPocoDelSol() { direccion = -10.max(direccion - 1) }
	method cargarCombustible(cuanto) { combustible += cuanto }
	method descargarCombustible(cuanto) { combustible = 0.max(combustible -cuanto) }
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila() {
		return combustible >= 4000 and velocidad <= 12000 and self.adicionalTranquilidad()
	}
	method adicionalTranquilidad()
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method escapar() //metodo abstracto
	method avisar() //metodo abstracto
	method estaDeRelajo() {
		return self.estaTranquila() and self.tienePocaActividad()
	}
	method tienePocaActividad() //metodo abstracto
}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza = "azul" //azul será el valor inicial
	var cambioDeColor = false
	
	method cambiarColorDeBaliza(colorNuevo) { 
		colorBaliza = colorNuevo
		cambioDeColor = true
	}
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method adicionalTranquilidad() = colorBaliza != "rojo"
	override method escapar() {self.irHaciaElSol()}
	override method avisar() {self.cambiarColorDeBaliza("rojo")}
	override method tienePocaActividad() = not cambioDeColor
}

class NaveDePasajeros inherits NaveEspacial {
	const cantidadDePasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var racionesDeComidaServidas= 0
	
	method racionesDeComida() = racionesDeComida
	method racionesDeBebida() = racionesDeBebida
	method racionesDeComidaServidas() = racionesDeComidaServidas
	
	method servirComida(cuanto) {
		racionesDeComidaServidas += racionesDeComida.min(cuanto)
		self.descargarComida(cuanto)
		
	}
	method cargarComida(cuanto) { racionesDeComida += cuanto }
	method cargarBebida(cuanto) { racionesDeBebida += cuanto }
	method descargarComida(cuanto) { 
		racionesDeComida = 0.max(racionesDeComida - cuanto)
	}
	method descargarBebida(cuanto) { racionesDeBebida = 0.max(racionesDeBebida - cuanto) }
	override method prepararViaje() {
		super()
		self.cargarComida(cantidadDePasajeros*4)
		self.cargarBebida(cantidadDePasajeros*6)
		self.acercarseUnPocoAlSol()
	}
	override method adicionalTranquilidad() = true
	override method escapar() {self.acelerar(velocidad)}
	override method avisar() {
		self.servirComida(cantidadDePasajeros)
		self.descargarBebida(cantidadDePasajeros*2)
	}
	override method tienePocaActividad() = racionesDeComidaServidas < 50
	method valores() {
		console.println("racionesDeComida: "+ racionesDeComida)
		console.println("racionesDeBebida: "+ racionesDeBebida)
		console.println("racionesDeComidaServidas: "+ racionesDeComidaServidas)
	}
}

class NaveHospital inherits NaveDePasajeros {
	var quirofanosPreparados = false
	method prepararQuirofanos() { quirofanosPreparados = true }
	method noPrepararQuirofanos() { quirofanosPreparados = false }
	override method adicionalTranquilidad() = not quirofanosPreparados
	override method recibirAmenaza() {
		super()
		self.prepararQuirofanos()
	}
}

class NaveDeCombate inherits NaveEspacial {
	var estaVisible = false
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible() { estaVisible = true }
	method ponerseInvisible() { estaVisible = false }
	method estaInvisible() = not estaVisible
	
	method desplegarMisiles() { misilesDesplegados = true }
	method replegarMisiles() { misilesDesplegados = false }
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje) { mensajes.add(mensaje) }
	method mensajesEmitidos() = mensajes
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = not mensajes.any({m=>m.size()>30})
					 	 // mensajes.all({m=>m.length()<=30})
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	override method prepararViaje() {
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method adicionalTranquilidad() = not self.misilesDesplegados()
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar() {self.emitirMensaje("Amenaza recibida")}
	override method tienePocaActividad() = self.esEscueta()
}

class NaveSigilosa inherits NaveDeCombate {
	override method adicionalTranquilidad() {
		return super() and not self.estaInvisible()
	}
	override method escapar() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}