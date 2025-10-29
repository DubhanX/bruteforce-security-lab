from flask import Flask, render_template, request, session, redirect, url_for, flash
import logging
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'vulnerable-secret-key-123'

logging.basicConfig(
    filename='/app/logs/access.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

USERS_DB = {
    'admin': 'admin123',
    'user': 'password',
    'test': 'test123',
    'demo': 'demo123',
    'guest': 'guest',
}

@app.route('/')
def index():
    if 'username' in session:
        return redirect(url_for('dashboard'))
    return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username', '')
        password = request.form.get('password', '')
        ip_address = request.remote_addr
        
        logging.info(f"Login attempt - IP: {ip_address}, Username: {username}")
        
        if username in USERS_DB:
            if USERS_DB[username] == password:
                session['username'] = username
                session['login_time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                logging.info(f"Successful login - User: {username}, IP: {ip_address}")
                flash(f'¡Bienvenido {username}!', 'success')
                return redirect(url_for('dashboard'))
            else:
                logging.warning(f"Failed login - Wrong password: {username}, IP: {ip_address}")
                flash('Contraseña incorrecta', 'danger')
                return render_template('login.html', username=username)
        else:
            logging.warning(f"Failed login - User not found: {username}, IP: {ip_address}")
            flash('Usuario no encontrado', 'danger')
            return render_template('login.html')
    
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'username' not in session:
        flash('Debes iniciar sesión primero', 'warning')
        return redirect(url_for('login'))
    
    user_info = {
        'username': session['username'],
        'login_time': session.get('login_time', 'Desconocido'),
        'role': 'Administrador' if session['username'] == 'admin' else 'Usuario'
    }
    
    return render_template('dashboard.html', user=user_info)

@app.route('/logout')
def logout():
    username = session.get('username', 'Unknown')
    logging.info(f"Logout - User: {username}")
    session.clear()
    flash('Sesión cerrada correctamente', 'info')
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
