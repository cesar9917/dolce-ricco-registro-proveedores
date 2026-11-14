package modelo;

public enum TipoReporte {
    PROVEEDORES_ACTIVOS("01 · Proveedores activos y evaluadores"),
    PRODUCTOS_POR_PROVEEDOR("02 · Productos por proveedor activo y aprobado"),
    COMPRAS_POR_PROVEEDOR("03 · Compras por proveedor y moneda"),
    COMPRAS_POR_MES("04 · Compras por mes y moneda"),
    FACTURAS_POR_PROVEEDOR("05 · Facturas por proveedor y fechas"),
    PROVEEDORES_SIN_COMPRAS("06 · Proveedores sin compras"),
    ALERTAS_HACCP("07 · HACCP vencidos o por vencer en 90 días"),
    ALERTAS_SANITARIAS("08 · Registros sanitarios vencidos o por vencer en 90 días"),
    DOCUMENTACION_INCOMPLETA("09 · Proveedores con documentación incompleta"),
    PRODUCTOS_VARIOS_PROVEEDORES("10 · Productos con varios proveedores disponibles"),
    FACTURAS_CREDITO("11 · Facturas emitidas a crédito"),
    EVALUADORES("12 · Cantidad de proveedores por evaluador");

    private final String etiqueta;

    TipoReporte(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public boolean requiereRango() {
        return this == FACTURAS_POR_PROVEEDOR;
    }

    @Override
    public String toString() {
        return etiqueta;
    }
}