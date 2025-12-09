#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# ============================================================================
# APPLICATION R SHINY - ANALYSE DU CHURN BANCAIRE
# Projet Master 2 MIAGE
# ============================================================================



library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)
library(plotly)
library(rsconnect)


users_db <- data.frame(
  username = c("admin", "analyst", "manager"),
  password = c(
    digest("admin123", algo = "sha256"),
    digest("analyst123", algo = "sha256"),
    digest("manager123", algo = "sha256")
  ),
  nom_complet = c("Administrateur", "Analyste Principal", "Responsable"),
  role = c("admin", "analyst", "manager"),
  
  stringsAsFactors = FALSE
)
# ============================================================================
# CHARGEMENT DES DONNÉES
# ============================================================================


# Charger les données
df <- read.csv("C:/Users/HP/churn_bancaire/data/donnees_churn_bancaire.csv", encoding = "UTF-8")


# Convertir la variable churn en facteur
df$churn_label <- factor(df$churn, levels = c(0, 1), labels = c("Non", "Oui"))
df$carte_credit_label <- factor(df$carte_credit, levels = c(0, 1), 
                                labels = c("Non", "Oui"))
df$membre_actif_label <- factor(df$membre_actif, levels = c(0, 1), 
                                labels = c("Inactif", "Actif"))

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      /* Style pour la page de connexion */
      .login-page {
        width: 100%;
        height: 100vh;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 9999;
      }
      
      .login-box {
        background: white;
        padding: 50px;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        width: 400px;
        max-width: 90%;
      }
      
      .login-header {
        text-align: center;
        margin-bottom: 40px;
      }
      
      .login-header i {
        font-size: 48px;
        color: #667eea;
        margin-bottom: 15px;
      }
      
      .login-header h2 {
        color: #667eea;
        font-weight: 700;
        margin-bottom: 10px;
        font-size: 24px;
      }
      
      .login-header p {
        color: #6c757d;
        font-size: 14px;
      }
      
      .form-group {
        margin-bottom: 25px;
      }
      
      .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #495057;
        font-weight: 500;
      }
      
      .input-wrapper {
        position: relative;
      }
      
      .input-wrapper i {
        position: absolute;
        left: 12px;
        top: 12px;
        color: #6c757d;
      }
      
      .input-wrapper input {
        padding-left: 35px !important;
        width: 100%;
      }
      
      #login_button {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s;
        width: 100%;
      }
      
      #login_button:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
      }
      
      .error-message {
        background: #f8d7da;
        color: #721c24;
        padding: 12px;
        border-radius: 6px;
        margin-top: 15px;
        border: 1px solid #f5c6cb;
        display: none;
      }
      
      .error-message.show {
        display: block;
      }
      
      .demo-accounts {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #dee2e6;
        text-align: center;
      }
      
      .demo-accounts p {
        color: #6c757d;
        font-size: 13px;
        margin-bottom: 8px;
        font-weight: 500;
      }
      
      .demo-accounts table {
        width: 100%;
        font-size: 12px;
        color: #6c757d;
      }
      
      .demo-accounts td {
        padding: 4px;
      }
      
      .demo-accounts td:first-child {
        text-align: left;
        font-weight: bold;
      }
      
      .demo-accounts td:last-child {
        text-align: right;
        font-family: monospace;
      }
    "))
  ),
  
  # Contenu conditionnel
  uiOutput("page_content")
)


# ============================================================================
# INTERFACE UTILISATEUR (UI)
# ============================================================================

ui <- dashboardPage(
  skin = "blue",
  
  # En-tête
  dashboardHeader(
    title = "Analyse du Churn Bancaire",
    titleWidth = 300
  ),
  
  # Barre latérale
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      menuItem("Tableau de Bord", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Données", tabName = "data", icon = icon("table")),
      menuItem("Visualisations", tabName = "viz", icon = icon("chart-bar")),
      menuItem("Analyse Détaillée", tabName = "analysis", icon = icon("search")),
      menuItem("Prédiction", tabName = "prediction", icon = icon("bullseye")),
      menuItem("À propos", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  # Corps principal
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #ecf0f5; }
        .box { border-top: 3px solid #3c8dbc; }
        h2 { color: #3c8dbc; font-weight: bold; }
        .info-box { min-height: 90px; }
      "))
    ),
    
    
    tabItems(
      # ========================================================================
      # TAB 1: TABLEAU DE BORD
      # ========================================================================
      tabItem(
        tabName = "dashboard",
        h2("Tableau de Bord - Vue d'ensemble"),
        
        # Ligne 1: Indicateurs clés
        fluidRow(
          infoBoxOutput("total_clients", width = 3),
          infoBoxOutput("taux_churn", width = 3),
          infoBoxOutput("clients_actifs", width = 3),
          infoBoxOutput("age_moyen", width = 3)
        ),
        
        # Ligne 2: Graphiques principaux
        fluidRow(
          box(
            title = "Répartition du Churn",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_churn_pie", height = 300)
          ),
          box(
            title = "Churn par Pays",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_churn_country", height = 300)
          )
        ),
        
        # Ligne 3: Graphiques supplémentaires
        fluidRow(
          box(
            title = "Distribution de l'Âge",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_age_dist", height = 300)
          ),
          box(
            title = "Churn par Nombre de Produits",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_products", height = 300)
          )
        )
      ),
      
      # ========================================================================
      # TAB 2: DONNÉES
      # ========================================================================
      tabItem(
        tabName = "data",
        h2("Exploration des Données"),
        
        fluidRow(
          box(
            title = "Filtres",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            column(3,
                   selectInput("filter_pays", "Pays:", 
                               choices = c("Tous", unique(df$pays)),
                               selected = "Tous")
            ),
            column(3,
                   selectInput("filter_genre", "Genre:", 
                               choices = c("Tous", unique(df$genre)),
                               selected = "Tous")
            ),
            column(3,
                   selectInput("filter_churn", "Churn:", 
                               choices = c("Tous", "Non", "Oui"),
                               selected = "Tous")
            ),
            column(3,
                   sliderInput("filter_age", "Âge:",
                               min = min(df$age),
                               max = max(df$age),
                               value = c(min(df$age), max(df$age)))
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Tableau des Données",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("data_table")
          )
        )
      ),
      
      # ========================================================================
      # TAB 3: VISUALISATIONS
      # ========================================================================
      tabItem(
        tabName = "viz",
        h2("Visualisations Avancées"),
        
        fluidRow(
          box(
            title = "Sélection du Graphique",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            selectInput("viz_type", "Choisir une visualisation:",
                        choices = c(
                          "Churn par Genre" = "genre",
                          "Churn selon Statut Membre" = "membre",
                          "Score de Crédit vs Solde" = "credit_solde",
                          "Ancienneté vs Churn" = "anciennete",
                          "Salaire vs Churn" = "salaire"
                        ))
          )
        ),
        
        fluidRow(
          box(
            title = "Graphique",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("custom_viz", height = 500)
          )
        )
      ),
      
      # ========================================================================
      # TAB 4: ANALYSE DÉTAILLÉE
      # ========================================================================
      tabItem(
        tabName = "analysis",
        h2("Analyse Détaillée"),
        
        fluidRow(
          box(
            title = "Statistiques par Pays",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            DTOutput("stats_pays")
          ),
          box(
            title = "Statistiques par Genre",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            DTOutput("stats_genre")
          )
        ),
        
        fluidRow(
          box(
            title = "Corrélations",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("correlation_plot", height = 500)
          )
        )
      ),
      
      # ========================================================================
      # TAB 5: PRÉDICTION
      # ========================================================================
      tabItem(
        tabName = "prediction",
        h2("Simulateur de Prédiction de Churn"),
        
        fluidRow(
          box(
            title = "Informations du Client",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            sliderInput("pred_age", "Âge:", 
                        min = 18, max = 80, value = 35),
            sliderInput("pred_credit", "Score de Crédit:", 
                        min = 350, max = 850, value = 600),
            sliderInput("pred_anciennete", "Ancienneté (années):", 
                        min = 0, max = 15, value = 5),
            sliderInput("pred_solde", "Solde:", 
                        min = 0, max = 250000, value = 100000, step = 1000),
            sliderInput("pred_produits", "Nombre de Produits:", 
                        min = 1, max = 4, value = 2),
            selectInput("pred_pays", "Pays:", 
                        choices = unique(df$pays)),
            selectInput("pred_genre", "Genre:", 
                        choices = unique(df$genre)),
            selectInput("pred_carte", "Carte de Crédit:", 
                        choices = c("Non" = 0, "Oui" = 1)),
            selectInput("pred_actif", "Membre Actif:", 
                        choices = c("Inactif" = 0, "Actif" = 1)),
            sliderInput("pred_salaire", "Salaire Estimé:", 
                        min = 15000, max = 200000, value = 100000, step = 1000),
            actionButton("predict_btn", "Calculer le Risque", 
                         class = "btn-primary btn-lg", width = "100%")
          ),
          box(
            title = "Résultat de la Prédiction",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            uiOutput("prediction_result")
          )
        )
      ),
      
      # ========================================================================
      # TAB 6: À PROPOS
      # ========================================================================
      tabItem(
        tabName = "about",
        h2("À propos du Projet"),
        
        fluidRow(
          box(
            title = "Description",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            HTML("
              <h3>Projet d'Analyse du Churn Bancaire</h3>
              <p><strong>Objectif:</strong> Analyser et prédire le churn (attrition) des clients bancaires.</p>
              
              <h4>Méthodologie:</h4>
              <ul>
                <li><strong>Exploration:</strong> Analyse statistique et visualisation des données</li>
                <li><strong>Modélisation:</strong> Utilisation de modèles de Machine Learning</li>
                <li><strong>Évaluation:</strong> Comparaison des performances des modèles</li>
                <li><strong>Déploiement:</strong> Application web interactive pour la visualisation</li>
              </ul>
              
              <h4>Dataset:</h4>
              <ul>
                <li>10 000 clients bancaires</li>
                <li>12 variables (âge, solde, pays, etc.)</li>
                <li>Variable cible: churn (0 = reste, 1 = part)</li>
              </ul>
              
              <h4>Technologies utilisées:</h4>
              <ul>
                <li><strong>Python:</strong> pandas, scikit-learn, matplotlib, seaborn</li>
                <li><strong>R:</strong> shiny, ggplot2, dplyr, plotly</li>
                <li><strong>Machine Learning:</strong> Régression Logistique, Arbre de Décision, Random Forest</li>
              </ul>
              
              <hr>
              <p><em>Projet Master 2 MIAGE - Analyse de Données</em></p>
            ")
          )
        )
      )
    )
  )
)

# ============================================================================
# SERVEUR
# ============================================================================

server <- function(input, output, session) {
  
  # ==========================================================================
  # TAB 1: TABLEAU DE BORD - Indicateurs
  # ==========================================================================
  
  output$total_clients <- renderInfoBox({
    infoBox(
      "Total Clients",
      format(nrow(df), big.mark = " "),
      icon = icon("users"),
      color = "blue",
      fill = TRUE
    )
  })
  
  output$taux_churn <- renderInfoBox({
    taux <- mean(df$churn) * 100
    infoBox(
      "Taux de Churn",
      paste0(round(taux, 2), "%"),
      icon = icon("exclamation-triangle"),
      color = "red",
      fill = TRUE
    )
  })
  
  output$clients_actifs <- renderInfoBox({
    n_actifs <- sum(df$membre_actif == 1)
    infoBox(
      "Clients Actifs",
      format(n_actifs, big.mark = " "),
      icon = icon("check-circle"),
      color = "green",
      fill = TRUE
    )
  })
  
  output$age_moyen <- renderInfoBox({
    infoBox(
      "Âge Moyen",
      paste0(round(mean(df$age), 1), " ans"),
      icon = icon("birthday-cake"),
      color = "purple",
      fill = TRUE
    )
  })
  
  # ==========================================================================
  # TAB 1: GRAPHIQUES
  # ==========================================================================
  
  output$plot_churn_pie <- renderPlotly({
    churn_counts <- df %>%
      group_by(churn_label) %>%
      summarise(count = n()) %>%
      mutate(pct = round(count / sum(count) * 100, 1))
    
    plot_ly(churn_counts, labels = ~churn_label, values = ~count, type = 'pie',
            textposition = 'inside',
            textinfo = 'label+percent',
            marker = list(colors = c('#2ecc71', '#e74c3c')),
            showlegend = TRUE) %>%
      layout(title = "",
             margin = list(l = 0, r = 0, t = 0, b = 0))
  })
  
  output$plot_churn_country <- renderPlotly({
    churn_by_country <- df %>%
      group_by(pays, churn_label) %>%
      summarise(count = n(), .groups = 'drop') %>%
      group_by(pays) %>%
      mutate(pct = round(count / sum(count) * 100, 1))
    
    plot_ly(churn_by_country, x = ~pays, y = ~pct, color = ~churn_label,
            type = 'bar',
            colors = c('#2ecc71', '#e74c3c'),
            text = ~paste0(pct, "%"),
            textposition = 'auto') %>%
      layout(yaxis = list(title = "Pourcentage (%)"),
             xaxis = list(title = "Pays"),
             barmode = 'stack',
             showlegend = TRUE,
             legend = list(title = list(text = 'Churn')))
  })
  
  output$plot_age_dist <- renderPlotly({
    plot_ly(df, x = ~age, color = ~churn_label, type = "histogram",
            colors = c('#2ecc71', '#e74c3c'),
            opacity = 0.7) %>%
      layout(barmode = "overlay",
             xaxis = list(title = "Âge"),
             yaxis = list(title = "Fréquence"),
             legend = list(title = list(text = 'Churn')))
  })
  
  output$plot_products <- renderPlotly({
    churn_by_products <- df %>%
      group_by(nb_produits, churn_label) %>%
      summarise(count = n(), .groups = 'drop') %>%
      group_by(nb_produits) %>%
      mutate(pct = round(count / sum(count) * 100, 1))
    
    plot_ly(churn_by_products, x = ~nb_produits, y = ~pct, color = ~churn_label,
            type = 'bar',
            colors = c('#2ecc71', '#e74c3c'),
            text = ~paste0(pct, "%"),
            textposition = 'auto') %>%
      layout(yaxis = list(title = "Pourcentage (%)"),
             xaxis = list(title = "Nombre de Produits"),
             barmode = 'stack',
             showlegend = TRUE,
             legend = list(title = list(text = 'Churn')))
  })
  
  # ==========================================================================
  # TAB 2: DONNÉES FILTRÉES
  # ==========================================================================
  
  filtered_data <- reactive({
    data <- df
    
    if (input$filter_pays != "Tous") {
      data <- data %>% filter(pays == input$filter_pays)
    }
    
    if (input$filter_genre != "Tous") {
      data <- data %>% filter(genre == input$filter_genre)
    }
    
    if (input$filter_churn != "Tous") {
      churn_val <- ifelse(input$filter_churn == "Oui", 1, 0)
      data <- data %>% filter(churn == churn_val)
    }
    
    data <- data %>% filter(age >= input$filter_age[1] & age <= input$filter_age[2])
    
    return(data)
  })
  
  output$data_table <- renderDT({
    datatable(
      filtered_data() %>% 
        select(id_client, age, genre, pays, score_credit, solde, 
               nb_produits, anciennete, churn_label),
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        language = list(
          url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/French.json'
        )
      ),
      filter = 'top',
      rownames = FALSE
    )
  })
  
  # ==========================================================================
  # TAB 3: VISUALISATIONS PERSONNALISÉES
  # ==========================================================================
  
  output$custom_viz <- renderPlotly({
    if (input$viz_type == "genre") {
      churn_by_gender <- df %>%
        group_by(genre, churn_label) %>%
        summarise(count = n(), .groups = 'drop') %>%
        group_by(genre) %>%
        mutate(pct = round(count / sum(count) * 100, 1))
      
      plot_ly(churn_by_gender, x = ~genre, y = ~pct, color = ~churn_label,
              type = 'bar',
              colors = c('#2ecc71', '#e74c3c'),
              text = ~paste0(pct, "%"),
              textposition = 'auto') %>%
        layout(yaxis = list(title = "Pourcentage (%)"),
               xaxis = list(title = "Genre"),
               barmode = 'group',
               showlegend = TRUE)
      
    } else if (input$viz_type == "membre") {
      churn_by_member <- df %>%
        group_by(membre_actif_label, churn_label) %>%
        summarise(count = n(), .groups = 'drop') %>%
        group_by(membre_actif_label) %>%
        mutate(pct = round(count / sum(count) * 100, 1))
      
      plot_ly(churn_by_member, x = ~membre_actif_label, y = ~pct, 
              color = ~churn_label,
              type = 'bar',
              colors = c('#2ecc71', '#e74c3c'),
              text = ~paste0(pct, "%"),
              textposition = 'auto') %>%
        layout(yaxis = list(title = "Pourcentage (%)"),
               xaxis = list(title = "Statut de Membre"),
               barmode = 'group',
               showlegend = TRUE)
      
    } else if (input$viz_type == "credit_solde") {
      plot_ly(df, x = ~score_credit, y = ~solde, color = ~churn_label,
              type = 'scatter', mode = 'markers',
              colors = c('#2ecc71', '#e74c3c'),
              marker = list(size = 5, opacity = 0.6)) %>%
        layout(xaxis = list(title = "Score de Crédit"),
               yaxis = list(title = "Solde"),
               showlegend = TRUE)
      
    } else if (input$viz_type == "anciennete") {
      churn_by_tenure <- df %>%
        group_by(anciennete, churn_label) %>%
        summarise(count = n(), .groups = 'drop')
      
      plot_ly(churn_by_tenure, x = ~anciennete, y = ~count, 
              color = ~churn_label,
              type = 'bar',
              colors = c('#2ecc71', '#e74c3c')) %>%
        layout(yaxis = list(title = "Nombre de clients"),
               xaxis = list(title = "Ancienneté (années)"),
               barmode = 'group',
               showlegend = TRUE)
      
    } else if (input$viz_type == "salaire") {
      plot_ly(df, x = ~salaire_estime, color = ~churn_label,
              type = "histogram",
              colors = c('#2ecc71', '#e74c3c'),
              opacity = 0.7) %>%
        layout(barmode = "overlay",
               xaxis = list(title = "Salaire Estimé"),
               yaxis = list(title = "Fréquence"),
               showlegend = TRUE)
    }
  })
  
  # ==========================================================================
  # TAB 4: STATISTIQUES DÉTAILLÉES
  # ==========================================================================
  
  output$stats_pays <- renderDT({
    stats <- df %>%
      group_by(pays) %>%
      summarise(
        Clients = n(),
        `Taux Churn (%)` = round(mean(churn) * 100, 2),
        `Âge Moyen` = round(mean(age), 1),
        `Solde Moyen` = round(mean(solde), 0),
        `Score Crédit Moyen` = round(mean(score_credit), 0)
      )
    
    datatable(stats, options = list(dom = 't'), rownames = FALSE)
  })
  
  output$stats_genre <- renderDT({
    stats <- df %>%
      group_by(genre) %>%
      summarise(
        Clients = n(),
        `Taux Churn (%)` = round(mean(churn) * 100, 2),
        `Âge Moyen` = round(mean(age), 1),
        `Solde Moyen` = round(mean(solde), 0),
        `Score Crédit Moyen` = round(mean(score_credit), 0)
      )
    
    datatable(stats, options = list(dom = 't'), rownames = FALSE)
  })
  
  output$correlation_plot <- renderPlotly({
    numeric_cols <- df %>% 
      select(score_credit, age, anciennete, solde, nb_produits, 
             carte_credit, membre_actif, salaire_estime, churn)
    
    cor_matrix <- cor(numeric_cols)
    
    plot_ly(z = cor_matrix, x = colnames(cor_matrix), y = colnames(cor_matrix),
            type = "heatmap", colorscale = "RdBu",
            zmid = 0, zmin = -1, zmax = 1,
            text = round(cor_matrix, 2),
            texttemplate = "%{text}",
            textfont = list(size = 10)) %>%
      layout(xaxis = list(tickangle = -45),
             margin = list(l = 100, b = 100))
  })
  
  # ==========================================================================
  # TAB 5: PRÉDICTION
  # ==========================================================================
  
  observeEvent(input$predict_btn, {
    
    # Calcul simple du risque basé sur des règles métier
    risk_score <- 0.2  # score de base
    
    # Âge
    if (input$pred_age < 25 || input$pred_age > 65) {
      risk_score <- risk_score + 0.1
    }
    
    # Score de crédit
    if (input$pred_credit < 500) {
      risk_score <- risk_score + 0.15
    }
    
    # Solde
    if (input$pred_solde < 50000) {
      risk_score <- risk_score + 0.1
    }
    
    # Nombre de produits
    if (input$pred_produits == 1) {
      risk_score <- risk_score + 0.15
    }
    
    # Carte de crédit
    if (input$pred_carte == "0") {
      risk_score <- risk_score + 0.1
    }
    
    # Membre actif
    if (input$pred_actif == "0") {
      risk_score <- risk_score + 0.2
    }
    
    # Pays (l'Allemagne a plus de churn)
    if (input$pred_pays == "Allemagne") {
      risk_score <- risk_score + 0.1
    }
    
    # Limiter le score entre 0 et 1
    risk_score <- min(risk_score, 0.95)
    
    # Déterminer le niveau de risque
    if (risk_score < 0.3) {
      risk_level <- "FAIBLE"
      risk_color <- "green"
      risk_icon <- "check-circle"
    } else if (risk_score < 0.6) {
      risk_level <- "MOYEN"
      risk_color <- "orange"
      risk_icon <- "exclamation-circle"
    } else {
      risk_level <- "ÉLEVÉ"
      risk_color <- "red"
      risk_icon <- "times-circle"
    }
    
    output$prediction_result <- renderUI({
      tagList(
        div(style = "text-align: center; padding: 20px;",
            div(style = paste0("font-size: 48px; color: ", risk_color, ";"),
                icon(risk_icon)),
            h3(paste("Risque de Churn:", risk_level),
               style = paste0("color: ", risk_color, "; font-weight: bold;")),
            h4(paste0("Probabilité: ", round(risk_score * 100, 1), "%")),
            hr(),
            h4("Recommandations:"),
            if (risk_score > 0.5) {
              tags$ul(style = "text-align: left;",
                      tags$li("Contacter le client rapidement"),
                      tags$li("Proposer des offres personnalisées"),
                      tags$li("Améliorer l'engagement client"),
                      tags$li("Augmenter le nombre de produits"))
            } else {
              tags$ul(style = "text-align: left;",
                      tags$li("Maintenir la relation actuelle"),
                      tags$li("Surveiller les indicateurs"),
                      tags$li("Proposer des services additionnels"))
            }
        )
      )
    })
  })
}

# ============================================================================
# LANCEMENT DE L'APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)


