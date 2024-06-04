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
}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza
	
	method cambiarColorDeBaliza(colorNuevo) { colorBaliza = colorNuevo}
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
}

class NaveDePasajeros inherits NaveEspacial {
	const cantidadDePasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	
	method cargarComida(cuanto) { racionesDeComida += cuanto }
	method cargarBebida(cuanto) { racionesDeBebida += cuanto }
	method descargarComida(cuanto) { racionesDeComida = 0.max(racionesDeComida - cuanto) }
	method descargarBebida(cuanto) { racionesDeBebida = 0.max(racionesDeBebida - cuanto) }
	override method prepararViaje() {
		super()
		self.cargarComida(cantidadDePasajeros*4)
		self.cargarBebida(cantidadDePasajeros*6)
		self.acercarseUnPocoAlSol()
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
}