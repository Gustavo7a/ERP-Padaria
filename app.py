import streamlit as st
from database.connection import testar_conexao

st.set_page_config(page_title="ERP Padaria Artesanal", layout="wide")

st.title("ERP Padaria Artesanal & Cafeteria")
st.caption("Sistema de Gestão Integrado - UFAPE 2026.2")

try: 
    tabelas = testar_conexao()
    st.success(f"Conectado ao Supabase com sucesso! {len(tabelas)} tabelas encontradas.")
    with st.expander("Ver tabelas criadas no PostgreSQL"):
        st.write(tabelas)
except Exception as e:
    st.error(f"Erro ao conectar ao banco de dados: {e}")