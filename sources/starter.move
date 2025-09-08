module central_autobuses::central_autobuses {

    use std::string::{String, utf8};
    use sui::vec_map::{VecMap, Self};


    public struct Central has key, store {
        id:UID, 
        nombre:String, 
        autobuses: VecMap<u8, Autobus>
    }

    public struct Autobus has store, drop {
        chofer: String,
        ruta: String,
        numero: u8,
        pasajeros: u8,
        estado: String,
    }

    #[error]
    const NUMERO_NO_VALIDO: vector<u8> = b"Numero de autobus ya existente, intenta con otro";
    #[error]
    const AUTOBUS_NO_ENCONTRADO: u16 = 404;

    public fun crear_central(nombre: String, ctx: &mut TxContext) {

        let central = Central {
            id: object::new(ctx), 
            nombre, 
            autobuses: vec_map::empty()
        };

        transfer::transfer(central, tx_context::sender(ctx));
    }


    public fun agregar_ruta(central: &mut Central, chofer: String, ruta: String, numero:u8) {

        assert!(!central.autobuses.contains(&numero), NUMERO_NO_VALIDO);
        
        let autobus = Autobus {
            chofer,
            ruta,
            numero,
            pasajeros: 0,
            estado: utf8(b"En la central"),
        };

        central.autobuses.insert(numero, autobus);
    }

    public fun salida_autobus(central: &mut Central, numero: u8, pasajeros: u8) {
        
        assert!(central.autobuses.contains(&numero), AUTOBUS_NO_ENCONTRADO);

        let autobus = central.autobuses.get_mut(&numero);
        autobus.pasajeros = pasajeros;

        autobus.estado = utf8(b"En viaje");
    }

    public fun llegada_autobus(central: &mut Central, numero: u8) {
        
        assert!(central.autobuses.contains(&numero), AUTOBUS_NO_ENCONTRADO);

        let autobus = central.autobuses.get_mut(&numero);
        autobus.pasajeros = 0u8;

        autobus.estado = utf8(b"En central");
    }

    public fun borrar_ruta(central: &mut Central, numero: u8) {

        assert!(central.autobuses.contains(&numero), AUTOBUS_NO_ENCONTRADO);
        central.autobuses.remove(&numero);
    }


}
