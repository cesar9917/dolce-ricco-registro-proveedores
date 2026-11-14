package vista;

import javax.swing.table.DefaultTableModel;

final class TablaSoloLectura extends DefaultTableModel {
    private static final long serialVersionUID = 1L;

    @Override
    public boolean isCellEditable(int fila, int columna) {
        return false;
    }
}