package com.utp.model;

import java.io.Serializable;

public class Empleado implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String nombre;
    private String cargo;
    private double sueldo;
    private boolean activo;

    public Empleado() { }

    public Empleado(int id, String nombre, String cargo, double sueldo, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.cargo = cargo;
        this.sueldo = sueldo;
        this.activo = activo;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }
    public double getSueldo() { return sueldo; }
    public void setSueldo(double sueldo) { this.sueldo = sueldo; }
    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
}
