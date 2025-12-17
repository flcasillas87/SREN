# Usar Node.js como base
FROM node:20-alpine

# Establecer directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install --production

# Copiar el resto del código
COPY . .

# Puerto de la aplicación
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]
