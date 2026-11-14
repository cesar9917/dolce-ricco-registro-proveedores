package vista;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import modelo.ResultadoReporte;
import modelo.TipoReporte;

public final class ReportesPanel extends JPanel {
    private static final long serialVersionUID = 1L;

    private final JComboBox<TipoReporte> reportes = new JComboBox<>(TipoReporte.values());
    private final JTextField ruc = new JTextField(12);
    private final JTextField desde = new JTextField(10);
    private final JTextField hasta = new JTextField(10);
    private final JButton consultar = new JButton("Consultar");
    private final JPanel parametros = new JPanel(new FlowLayout(FlowLayout.LEADING, 8, 0));
    private final JLabel estado = new JLabel("Selecciona un reporte y pulsa Consultar.");
    private final TablaSoloLectura modelo = new TablaSoloLectura();

    public ReportesPanel() {
        super(new BorderLayout(0, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        JPanel superior = new JPanel(new BorderLayout(0, 8));
        JPanel acciones = new JPanel(new FlowLayout(FlowLayout.LEADING, 8, 0));
        agregarCampo(acciones, "Reporte", reportes);
        acciones.add(consultar);
        superior.add(acciones, BorderLayout.NORTH);
        agregarCampo(parametros, "RUC", ruc);
        agregarCampo(parametros, "Desde (AAAA-MM-DD)", desde);
        agregarCampo(parametros, "Hasta (AAAA-MM-DD)", hasta);
        superior.add(parametros, BorderLayout.SOUTH);
        add(superior, BorderLayout.NORTH);

        JTable tabla = new JTable(modelo);
        tabla.setAutoCreateRowSorter(true);
        tabla.setFillsViewportHeight(true);
        tabla.setRowHeight(26);
        tabla.getAccessibleContext().setAccessibleName("Resultados del reporte");
        add(new JScrollPane(tabla), BorderLayout.CENTER);
        add(estado, BorderLayout.SOUTH);

        reportes.addActionListener(evento -> {
            parametros.setVisible(tipo().requiereRango());
            limpiarResultado();
            mostrarEstado("Pulsa Consultar para cargar el reporte seleccionado.");
        });
        parametros.setVisible(false);
    }

    private static void agregarCampo(JPanel panel, String titulo, javax.swing.JComponent campo) {
        JLabel etiqueta = new JLabel(titulo);
        etiqueta.setLabelFor(campo);
        panel.add(etiqueta);
        panel.add(campo);
    }

    public void alConsultar(ActionListener accion) {
        consultar.addActionListener(accion);
        ruc.addActionListener(accion);
        desde.addActionListener(accion);
        hasta.addActionListener(accion);
    }

    public TipoReporte tipo() {
        return (TipoReporte) reportes.getSelectedItem();
    }

    public String ruc() {
        return ruc.getText();
    }

    public String desde() {
        return desde.getText();
    }

    public String hasta() {
        return hasta.getText();
    }

    public void limpiarResultado() {
        modelo.setDataVector(new Object[0][], new Object[0]);
    }

    public void mostrarResultado(ResultadoReporte resultado) {
        Object[][] datos = resultado.filas().stream().map(java.util.List::toArray).toArray(Object[][]::new);
        modelo.setDataVector(datos, resultado.columnas().toArray());
    }

    public void mostrarEstado(String mensaje) {
        estado.setText(mensaje);
    }

    public void setOcupado(boolean ocupado) {
        reportes.setEnabled(!ocupado);
        ruc.setEnabled(!ocupado);
        desde.setEnabled(!ocupado);
        hasta.setEnabled(!ocupado);
        consultar.setEnabled(!ocupado);
    }
}