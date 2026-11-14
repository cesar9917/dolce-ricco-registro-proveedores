package vista;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.util.List;
import java.util.Optional;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import modelo.DatosProveedor;
import modelo.Evaluacion;
import modelo.Evaluador;

public final class ProveedorDialogo {
    private ProveedorDialogo() {
    }

    public static Optional<DatosProveedor> solicitar(
            JComponent padre, List<Evaluador> evaluadores, boolean edicion, DatosProveedor inicial) {
        JTextField ruc = new JTextField(22);
        JTextField razon = new JTextField(28);
        JTextField direccion = new JTextField(28);
        JComboBox<Evaluacion> evaluacion = new JComboBox<>(Evaluacion.values());
        evaluacion.setSelectedItem(Evaluacion.OBSERVADO);
        JComboBox<Evaluador> evaluador = new JComboBox<>(evaluadores.toArray(Evaluador[]::new));
        evaluador.setSelectedIndex(-1);

        if (inicial != null) {
            ruc.setText(inicial.ruc());
            razon.setText(inicial.razonSocial());
            direccion.setText(inicial.direccion());
            evaluacion.setSelectedItem(inicial.evaluacion());
            evaluadores.stream().filter(e -> e.dni().equals(inicial.dniEvaluador()))
                    .findFirst().ifPresent(evaluador::setSelectedItem);
        }
        ruc.setEditable(!edicion);

        JPanel campos = new JPanel(new GridBagLayout());
        agregar(campos, 0, "RUC", ruc);
        agregar(campos, 1, "Razón social", razon);
        agregar(campos, 2, "Dirección", direccion);
        agregar(campos, 3, "Evaluación", evaluacion);
        agregar(campos, 4, "Evaluador", evaluador);

        String titulo = edicion ? "Editar proveedor" : "Nuevo proveedor";
        int respuesta = JOptionPane.showConfirmDialog(padre, campos, titulo,
                JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (respuesta != JOptionPane.OK_OPTION) {
            return Optional.empty();
        }
        Evaluador elegido = (Evaluador) evaluador.getSelectedItem();
        return Optional.of(new DatosProveedor(ruc.getText(), razon.getText(), direccion.getText(),
                (Evaluacion) evaluacion.getSelectedItem(), elegido == null ? null : elegido.dni()));
    }

    private static void agregar(JPanel panel, int fila, String texto, JComponent campo) {
        var posicion = new GridBagConstraints();
        posicion.gridy = fila;
        posicion.insets = new Insets(5, 6, 5, 6);
        posicion.anchor = GridBagConstraints.LINE_START;
        var etiqueta = new JLabel(texto);
        etiqueta.setLabelFor(campo);
        panel.add(etiqueta, posicion);
        posicion.gridx = 1;
        posicion.fill = GridBagConstraints.HORIZONTAL;
        posicion.weightx = 1;
        panel.add(campo, posicion);
    }
}