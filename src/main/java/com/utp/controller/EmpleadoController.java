package com.utp.controller;

import com.utp.model.Empleado;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

@ManagedBean(name = "empleadoController")
@ViewScoped
public class EmpleadoController implements Serializable {
    private static final long serialVersionUID = 1L;
    private List<Empleado> listaEmpleados;

    @PostConstruct
    public void inicializar() {
        listaEmpleados = new ArrayList<>();
        // Datos de prueba ficticios con cargos y sueldos corporativos plausibles.
        listaEmpleados.add(new Empleado(101, "Ana Torres", "Gerente de operaciones", 8500, true));
        listaEmpleados.add(new Empleado(102, "Luis Mendoza", "Analista de sistemas", 4800, true));
        listaEmpleados.add(new Empleado(103, "Carla Rojas", "Especialista de RR. HH.", 4200, false));
        listaEmpleados.add(new Empleado(104, "Diego Salazar", "Contador general", 5600, true));
        listaEmpleados.add(new Empleado(105, "Valeria Castro", "Coordinadora comercial", 4500, false));
    }
    public List<Empleado> getListaEmpleados() { return listaEmpleados; }
    public long getTotalActivos() {
        return listaEmpleados.stream().filter(Empleado::isActivo).count();
    }
    public void cambiarEstado(Empleado empleado) { empleado.setActivo(!empleado.isActivo()); }
    public void vaciarLista() { listaEmpleados.clear(); }
    public void restaurarDatos() { inicializar(); }
}
