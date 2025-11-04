# ------------- Stage 1: Build the React app -------------
FROM node:22.20.0 AS buildFiles

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# The build output (the static site) goes to /app/dist folder
RUN npm run build


# ------------- Stage 2: Serve the React app with Nginx -------------

# In Docker, your container is an isolated environment — it doesn’t have Live Server or VS Code (the way we are typically useing to run our frontend).
# So, we need something inside the container that can do the same job: serve your HTML/CSS/JS files to a browser.
# That “something” is Nginx

FROM nginx:alpine

# /usr/share/nginx/html → this is the default folder Nginx serves. Anything you put here will be available on the browser when the container runs.
# this line says: “Take the /app/dist folder from the build stage (i.e. the output of the React build), and copy it into /usr/share/nginx/html inside the Nginx image.”
COPY --from=buildFiles /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Define the port number for nginx is 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]