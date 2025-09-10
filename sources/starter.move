module starter::BancoTarjetas {
    use sui::vec_map::{VecMap, Self};
    use std::string::String;

    public struct Banco has key, store {
        id: UID,
        nombre: String,
        tarjetas: VecMap<u16, Tarjeta>
    }

    // Enumeración para tipo de tarjeta
    public enum TipoTarjeta has store, drop {
        Debito,
        Credito,
    }

    public struct Tarjeta has store, drop {
        nombre: String,
        numero: u16,
        tipo: TipoTarjeta,
    }

    #[error]
    const NUMERO_YA_EXISTE: vector<u8> = b"Numero de tarjeta ya existente";
    #[error]
    const TARJETA_NO_ENCONTRADA: u16 = 404;

    public fun crear_banco(nombre: String, ctx: &mut TxContext) {
        let banco = Banco {
            id: object::new(ctx),
            nombre,
            tarjetas: vec_map::empty(),
        };
        transfer::transfer(banco, tx_context::sender(ctx))
    }

    public fun agregar_tarjeta(banco: &mut Banco, id:u16, nombre: String, numero: u16, tipo: TipoTarjeta) {
        assert!(banco.tarjetas.contains(&numero), NUMERO_YA_EXISTE);

        let tarjeta = Tarjeta {
            nombre,
            numero,
            tipo,
        };

        banco.tarjetas.insert(id, tarjeta);
    }

    public fun borrar_tarjeta(banco: &mut Banco, numero: u16, id:u16 ) {

        assert!(!banco.tarjetas.contains(&numero), TARJETA_NO_ENCONTRADA);
        banco.tarjetas.remove(&id);
    }

}
