package vista;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Optional;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.DefaultListCellRenderer;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import modelo.EstadoProveedor;
import modelo.Proveedor;

public final class ProveedorPanel extends JPanel {
    private static final long serialVersionUID = 1L;
    private static final String[] COLUMNAS = {
        "RUC", "Razón social", "Dirección", "Estado", "Evaluación", "Evaluador"
    };

    private final JTextField texto = new JTextField(22);
    private final JComboBox<EstadoProveedor> filtro = new JComboBox<>(EstadoProveedor.values());
    private final JButton buscar = new JButton("Buscar");
    private final JButton registrar = new JButton("Nuevo proveedor");
    private final JButton editar = new JButton("Editar");
    private final JButton cambiarEstado = new JButton("Desactivar");
    private final JLabel estado = new JLabel(" ");
    private final TablaSoloLectura modelo = new TablaSoloLectura();
    private final JTable tabla = new JTable(modelo);

    private transient List<Proveedor> proveedores = List.of();
    private boolean ocupado;

    public ProveedorPanel() {
        super(new BorderLayout(0, 10));
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        JPanel herramientas = new JPanel(new FlowLayout(FlowLayout.LEADING, 8, 0));
        var etiquetaBusqueda = new JLabel("RUC o razón social");
        etiquetaBusqueda.setLabelFor(texto);
        var etiquetaEstado = new JLabel("Estado");
        etiquetaEstado.setLabelFor(filtro);
        filtro.insertItemAt(null, 0);
        filtro.setSelectedIndex(0);
        var renderizador = new DefaultListCellRenderer();
        filtro.setRenderer((lista, valor, indice, elegido, foco) ->
                renderizador.getListCellRendererComponent(
                        lista, valor == null ? "Todos" : valor, indice, elegido, foco));
        herramientas.add(etiquetaBusqueda);
        herramientas.add(texto);
        herramientas.add(etiquetaEstado);
        herramientas.add(filtro);
        herramientas.add(buscar);
        add(herramientas, BorderLayout.NORTH);

        tabla.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        tabla.setAutoCreateRowSorter(true);
        tabla.setFillsViewportHeight(true);
        tabla.setRowHeight(26);
        tabla.getAccessibleContext().setAccessibleName("Proveedores");
        tabla.getSelectionModel().addListSelectionListener(evento -> actualizarBotones());
        add(new JScrollPane(tabla), BorderLayout.CENTER);
        mostrarProveedores(List.of());

        JPanel acciones = new JPanel(new FlowLayout(FlowLayout.LEADING, 8, 0));
        acciones.add(registrar);
        acciones.add(editar);
        acciones.add(cambiarEstado);
        JPanel pie = new JPanel(new BorderLayout(12, 0));
        pie.add(acciones, BorderLayout.LINE_START);
        pie.add(estado, BorderLayout.CENTER);
        add(pie, BorderLayout.SOUTH);
    }

    public void alBuscar(ActionListener accion) {
        buscar.addActionListener(accion);
        texto.addActionListener(accion);
    }

    public void alRegistrar(ActionListener accion) {
        registrar.addActionListener(accion);
    }

    public void alEditar(ActionListener accion) {
        editar.addActionListener(accion);
    }

    public void alCambiarEstado(ActionListener accion) {
        cambiarEstado.addActionListener(accion);
    }

    public String textoBusqueda() {
        return texto.getText();
    }

    public EstadoProveedor estadoSeleccionado() {
        return (EstadoProveedor) filtro.getSelectedItem();
    }

    public Optional<Proveedor> proveedorSeleccionado() {
        int fila = tabla.getSelectedRow();
        return fila < 0 ? Optional.empty() : Optional.of(proveedores.get(tabla.convertRowIndexToModel(fila)));
    }

    public void mostrarProveedores(List<Proveedor> datos) {
        tabla.clearSelection();
        proveedores = List.copyOf(datos);
        Object[][] celdas = datos.stream().map(p -> new Object[] {
            p.datos().ruc(), p.datos().razonSocial(), p.datos().direccion(),
            p.estado(), p.datos().evaluacion(), p.nombreEvaluador()
        }).toArray(Object[][]::new);
        modelo.setDataVector(celdas, COLUMNAS);
        int[] anchos = {100, 225, 245, 75, 90, 170};
        for (int i = 0; i < anchos.length; i++) {
            tabla.getColumnModel().getColumn(i).setPreferredWidth(anchos[i]);
        }
        actualizarBotones();
    }

    public boolean confirmarCambio(Proveedor proveedor, EstadoProveedor destino) {
        var datos = proveedor.datos();
        String pregunta = destino == EstadoProveedor.INACTIVO
                ? "¿Desactivar a " + datos.razonSocial() + "? Se conservarán sus documentos y compras."
                : "¿Reactivar a " + datos.razonSocial() + "?";
        return JOptionPane.showConfirmDialog(this, pregunta, "Cambiar estado",
                JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE) == JOptionPane.OK_OPTION;
    }

    public void mostrarEstado(String mensaje) {
        estado.setText(mensaje);
    }

    public void setOcupado(boolean ocupado) {
        this.ocupado = ocupado;
        buscar.setEnabled(!ocupado);
        texto.setEnabled(!ocupado);
        filtro.setEnabled(!ocupado);
        tabla.setEnabled(!ocupado);
        registrar.setEnabled(!ocupado);
        actualizarBotones();
    }

    private void actualizarBotones() {
        var seleccionado = proveedorSeleccionado();
        editar.setEnabled(!ocupado && seleccionado.isPresent());
        cambiarEstado.setEnabled(!ocupado && seleccionado.isPresent());
        cambiarEstado.setText(seleccionado.filter(p -> p.estado() == EstadoProveedor.INACTIVO).isPresent()
                ? "Reactivar" : "Desactivar");
    }
}