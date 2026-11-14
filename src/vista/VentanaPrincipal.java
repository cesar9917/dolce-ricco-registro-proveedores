package vista;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;

public final class VentanaPrincipal extends JFrame {
    private static final long serialVersionUID = 1L;

    public VentanaPrincipal(ProveedorPanel proveedores, ReportesPanel reportes) {
        super("Dolce & Ricco | Registro de proveedores");
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        JLabel titulo = new JLabel("Dolce & Ricco  /  Registro de proveedores");
        titulo.setForeground(Color.WHITE);
        titulo.setFont(titulo.getFont().deriveFont(Font.BOLD, 20f));
        JPanel encabezado = new JPanel(new BorderLayout());
        encabezado.setBackground(new Color(57, 36, 29));
        encabezado.setBorder(BorderFactory.createEmptyBorder(16, 20, 16, 20));
        encabezado.add(titulo, BorderLayout.WEST);
        add(encabezado, BorderLayout.NORTH);

        JTabbedPane pestanas = new JTabbedPane();
        pestanas.addTab("Proveedores", proveedores);
        pestanas.addTab("Reportes", reportes);
        add(pestanas, BorderLayout.CENTER);

        setSize(1080, 625);
        setMinimumSize(new Dimension(850, 470));
        setLocationRelativeTo(null);
    }
}