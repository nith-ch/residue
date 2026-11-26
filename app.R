#Install Packages in R Console
#install.packages("shiny")
#install.packages("readxl")
#install.packages("ggplot2")
#install.packages("plotly")
#install.packages("DT")
#install.packages("dplyr")
#install.packages("nortest")

# ThinTin Toy Traders
# Residue Explorer


# 1.LOAD REQUIRED PACKAGES
# ============================================================


library(shiny)
library(readxl)
library(ggplot2)
library(plotly)
library(DT)
library(dplyr)
library(nortest)


# 2.LOAD CUSTOM FUNCTIONS

source("functions.R")


# 3.BRAND COLOURS AND THEME
# Apply ThinTin Toy Traders brand guidelines
# ============================================================

nursery_teal <- "#2F7F7B"
blush <- "#E8A0B4"
cream <- "#FFF8EE"
sunshine <- "#F2B705"

# Accessible status colours
# Keep red and green convention but add different shapes
investigation_red <- "#B42318"
normal_green <- "#18794E"

# Font
app_font <- "Nunito, Arial, sans-serif"


# 4.USER INTERFACE (UI)
# ============================================================

ui <- fluidPage(
  
  #4.1 Browser tab title and font
  
  tags$head(
    
    tags$title(
      "Residue Explorer - ThinTin Toy Traders"
    ),
    
    tags$link(
      rel = "preconnect",
      href = "https://fonts.googleapis.com"
    ),
    
    tags$link(
      rel = "preconnect",
      href = "https://fonts.gstatic.com",
      crossorigin = "anonymous"
    ),
    
    tags$link(
      href = paste0(
        "https://fonts.googleapis.com/css2?family=",
        "Nunito:wght@400;600;700;800&display=swap"
      ),
      rel = "stylesheet"
    ),
    
    #4.2 Custom CSS
    #Branding, contrast, focus and accessibility
    
    tags$style(HTML(paste0("

      body {
        background-color: ", cream, ";
        color: ", nursery_teal, ";
        font-family: ", app_font, ";
        font-size: 16px;
      }

      h1, h2, h3, h4, h5 {
        color: ", nursery_teal, ";
        font-weight: 800;
      }

      .main-header {
        background-color: ", nursery_teal, ";
        color: #FFFFFF;
        padding: 22px;
        margin-bottom: 20px;
        border-radius: 8px;
      }

      .main-header h1 {
        color: #FFFFFF;
        font-size: 28px;
        margin: 0;
      }

      .sidebar {
        background-color: ", blush, ";
        color: ", nursery_teal, ";
        padding: 18px;
        border-radius: 8px;
      }

      .panel-card {
        background-color: ", blush, ";
        color: ", nursery_teal, ";
        padding: 18px;
        border-radius: 8px;
        margin-bottom: 18px;
      }

      .btn, .btn-default, .btn-primary {
        background-color: ", sunshine, ";
        color: ", nursery_teal, ";
        border: 2px solid ", nursery_teal, ";
        font-weight: 800;
      }

      .btn:hover, .btn:focus,
      .btn-default:hover, .btn-default:focus,
      .btn-primary:hover, .btn-primary:focus {
        background-color: #E0A800;
        color: ", nursery_teal, ";
      }

      input, select {
        color: ", nursery_teal, ";
        border: 2px solid ", nursery_teal, ";
        min-height: 40px;
      }

      label {
        color: ", nursery_teal, ";
        font-weight: 700;
      }

      .form-control {
        border: 2px solid ", nursery_teal, ";
      }

      /* Visible keyboard focus */
      *:focus-visible {
        outline: 3px solid ", nursery_teal, " !important;
        outline-offset: 3px !important;
      }
      
      /* Cards */

      .summary-card {
      background-color: #FFFFFF;
      border: 2px solid #2F7F7B;
      border-radius: 12px;
      padding: 20px;
      text-align: center;
      margin: 5px;
      box-shadow: 0 3px 8px rgba(47, 127, 123, 0.12);
      }

      .summary-card h2 {
        font-size: 32px;
        font-weight: 800;
        margin-top: 5px;
        margin-bottom: 8px;
      }

      .summary-card p {
        font-size: 15px;
        font-weight: 700;
        margin-bottom: 0;
      }

      /* Accessible table */
      table.dataTable {
        color: ", nursery_teal, ";
        background-color: ", cream, ";
      }

      table.dataTable th {
        background-color: ", nursery_teal, ";
        color: #FFFFFF;
      }

      .status-text {
        font-weight: 800;
      }

      .download-area {
        margin: 12px 0 20px 0;
      }

      a {
        color: ", nursery_teal, ";
        text-decoration: underline;
      }

    "))
    ),
    
    
    #4.3 Main heading
    
    div(
      class = "main-header",
      h1("Residue Explorer")
    ),
    
    
    sidebarLayout(
      
    #4.4 SIDEBAR
    #Upload, Product selection and Threshold settings
      
      sidebarPanel(
        
        class = "sidebar",
        
        h3("Data Selection"),
        
        fileInput(
          "file",
          "Upload Dataset",
          accept = c(".csv", ".xlsx", ".xls")
        ),
        
        selectInput(
          "product",
          "Select Product",
          choices = NULL
        ),
        
        hr(),
        
        h3("Investigation Settings"),
        
        numericInput(
          "run_threshold",
          "Run Threshold",
          value = 70,
          min = 0
        ),
        
        numericInput(
          "run_length",
          "Run Length",
          value = 3,
          min = 1,
          step = 1
        ),
        
        numericInput(
          "single_threshold",
          "Single Threshold",
          value = 140,
          min = 0
        ),
        
        hr(),
        
        h3("Investigation Decision"),
        
        selectInput(
          "decision",
          "Decision",
          choices = c("Keep", "Remove")
        ),
        
        actionButton(
          "save_decision",
          "Save Decision"
        ),
        
        actionButton(
          "reset_decisions",
          "Reset Decisions"
        )
      ),
      
      
      #4.5 MAIN PANEL
      #Plots, review table and statistical summary
      
      mainPanel(
        
        width = 9,
        
        # 4.5.1 Summary Cards
        
        div(
          class = "panel-card",
          
          fluidRow(
            
            column(
              4,
              div(
                class = "summary-card",
                h2(textOutput("zero_count")),
                p("Zero Residue")
              )
            ),
            
            column(
              4,
              div(
                class = "summary-card",
                h2(textOutput("positive_count")),
                p("Positive Residue")
              )
            ),
            
            column(
              4,
              div(
                class = "summary-card",
                h2(textOutput("flag_count")),
                p("Investigation Points")
              )
            )
            
          )
        ),
        
        # ------------------------------------------------------
        # 4.5.2 Time Series Plot
        # ------------------------------------------------------
        
        div(
          class = "panel-card",
          
          h3("Results Over Time"),
          
          p(
            "Red triangles indicate results requiring investigation.",
            "Green circles indicate normal results."
          ),
          
          plotlyOutput(
            "result_plot",
            height = "420px"
          ),
          
          div(
            class = "download-area",
            
            downloadButton(
              "download_time_plot",
              "Download Time Series PNG"
            )
          )
        ),
        
        
        #4.5.2 Selected Point
        
        div(
          class = "panel-card",
          
          h3("Selected Investigation Point"),
          
          p(
            "Select a point on the chart or a row in the review table."
          ),
          
          DTOutput("selected_point")
        ),
        
        
        #4.5.3 Review Table
        
        div(
          class = "panel-card",
          
          h3("Investigation Review"),
          
          p(
            "Select a row to review its original date and row number."
          ),
          
          DTOutput("review_table")
        ),
        
        
        #4.5.4 Statistical Summary
        
        div(
          class = "panel-card",
          
          h3("Statistical Summary"),
          
          verbatimTextOutput("summary")
        ),
        
        
        #4.5.5 Density Plot
        
        div(
          class = "panel-card",
          
          h3("Positive Residue Density Plot"),
          
          plotOutput(
            "density_plot",
            height = "350px"
          ),
          
          downloadButton(
            "download_density_plot",
            "Download Density PNG"
          )
        ),
        
        
        #4.5.6 Anderson-Darling Test
        
        div(
          class = "panel-card",
          
          h3("Anderson-Darling Test"),
          
          verbatimTextOutput("ad_result")
        )
        
      )
    )
  )
) 
  
# 5.SERVER
# Application processing and analysis
# ============================================================
  
  server <- function(input, output, session) {
    
    
    #5.1 READ UPLOADED FILE
    #Support CSV and Excel
    
    raw_data <- reactive({
      
      req(input$file)
      
      ext <- tolower(
        tools::file_ext(input$file$name)
      )
      
      if (ext == "csv") {
        
        data <- read.csv(
          input$file$datapath,
          check.names = FALSE,
          stringsAsFactors = FALSE
        )
        
      } else if (ext %in% c("xlsx", "xls")) {
        
        data <- as.data.frame(
          read_excel(input$file$datapath)
        )
        
      } else {
        
        stop("Unsupported file format")
        
      }
      
      validate(
        need(nrow(data) > 0, "Uploaded file is empty."),
        need(ncol(data) >= 2,
             "File must contain a Date column and Product columns.")
      )
      
      data
      
    })
    
    
    #5.2 DYNAMIC PRODUCT SELECTION
    #Read product names from uploaded file
    
    observeEvent(raw_data(), {

  data <- raw_data()

  products <- names(data)[-1]

  updateSelectInput(
    session,
    "product",
    choices = products,
    selected = products[1]
  )

}, ignoreInit = FALSE)
    
    
    #5.3 PREPARE SELECTED PRODUCT DATA
    #Keep original row numbers
    #Exclude missing production days
    #Preserve zero residue
    
    
    selected_data <- reactive({
      
      data <- raw_data()
      
      # Wait until the selected product belongs to the new dataset
      req(input$product)
      req(input$product %in% names(data))
      
      date_values <- data[[1]]
      
      # Handle Excel numeric dates and text dates
      if (inherits(date_values, "Date")) {
        
        dates <- date_values
        
      } else if (inherits(date_values, "POSIXt")) {
        
        dates <- as.Date(date_values)
        
      } else if (is.numeric(date_values)) {
        
        dates <- as.Date(
          date_values,
          origin = "1899-12-30"
        )
        
      } else {
        
        dates <- as.Date(
          as.character(date_values)
        )
        
      }
      
      # Safely retrieve the selected product column
      original_values <- data[[input$product]]
      
      req(!is.null(original_values))
      req(length(original_values) == nrow(data))
      
      values <- suppressWarnings(
        as.numeric(as.character(original_values))
      )
      
      validate(
        need(
          !anyNA(dates),
          "Date column contains invalid dates."
        ),
        need(
          !any(is.na(values) & !is.na(original_values)),
          "Product column contains invalid numeric values."
        )
      )
      
      result <- data.frame(
        
        Date = dates,
        
        Value = values,
        
        Row_Number = seq_len(nrow(data))
        
      )
      
      # Keep only actual production results
      result <- result[!is.na(result$Value), , drop = FALSE]
      
      validate(
        need(
          nrow(result) > 0,
          "No production results found."
        )
      )
      
      result
      
    })
    
    
    #5.4 FLAG INVESTIGATION POINTS
    #Use original statistician function
    
    flagged_data <- reactive({
      
      data <- selected_data()
      
      validate(
        need(input$run_threshold >= 0,
             "Run Threshold must be non-negative."),
        need(input$single_threshold >= 0,
             "Single Threshold must be non-negative."),
        need(input$run_length >= 1,
             "Run Length must be at least 1."),
        need(input$run_length == as.integer(input$run_length),
             "Run Length must be a whole number.")
      )
      
      data$Flag <- flag_points(
        
        values = data$Value,
        
        run_threshold = input$run_threshold,
        
        run_length = as.integer(input$run_length),
        
        single_threshold = input$single_threshold
        
      )
      
      data
      
    })
    
    
    #5.5 STORE ANALYST DECISIONS
    #Keep original dataset unchanged
    
    decisions <- reactiveVal(NULL)
    
    #Reset Keep/Remove decisions when a new file is uploaded
    observeEvent(input$file, {
      decisions(NULL)
    }, ignoreInit = TRUE)
    
    observeEvent(flagged_data(), {
      
      data <- flagged_data()
      
      old <- decisions()
      
      updated <- data.frame(
        
        Row_Number = data$Row_Number,
        
        Decision = rep("Keep", nrow(data))
        
      )
      
      if (!is.null(old)) {
        
        matched <- match(
          updated$Row_Number,
          old$Row_Number
        )
        
        valid <- !is.na(matched)
        
        updated$Decision[valid] <-
          old$Decision[matched[valid]]
        
      }
      
      decisions(updated)
      
    })
    
    
    #5.6 RESET DECISIONS
    #Set all results back to Keep
    
    observeEvent(input$reset_decisions, {
      
      data <- flagged_data()
      
      decisions(
        data.frame(
          Row_Number = data$Row_Number,
          Decision = rep("Keep", nrow(data))
        )
      )
      
    })
    
    
    #5.7 COMBINE DATA AND DECISIONS

    
    review_data <- reactive({
      
      data <- flagged_data()
      
      decision_data <- decisions()
      
      req(decision_data)
      
      data$Decision <- decision_data$Decision[
        match(data$Row_Number, decision_data$Row_Number)
      ]
      
      data
      
    })
    
    
    #5.8 CREATE TIME SERIES PLOT
    #Red triangle = Investigation, Green circle = Normal
    
    time_plot <- reactive({
      
      data <- review_data()
      
      data$Status <- ifelse(
        data$Flag,
        "Investigation",
        "Normal"
      )
      
      ggplot(
        
        data,
        
        aes(
          x = Date,
          y = Value,
          color = Status,
          shape = Status,
          key = Row_Number,
          text = paste0(
            "Date: ", Date,
            "<br>Value: ", Value,
            "<br>Original Row: ", Row_Number,
            "<br>Status: ", Status,
            "<br>Decision: ", Decision
          )
        )
        
      ) +
        
        geom_line(
          aes(group = 1),
          color = nursery_teal,
          linewidth = 0.6
        ) +
        
        geom_point(
          size = 3.5,
          stroke = 1.2
        ) +
        
        scale_color_manual(
          values = c(
            "Normal" = normal_green,
            "Investigation" = investigation_red
          )
        ) +
        
        scale_shape_manual(
          values = c(
            "Normal" = 16,
            "Investigation" = 17
          )
        ) +
        
        labs(
          title = paste("Product:", input$product),
          x = "Date",
          y = "Residue (μg per part)",
          color = "Result Status",
          shape = "Result Status"
        ) +
        
        theme_minimal(
          base_family = "sans",
          base_size = 13
        ) +
        
        theme(
          text = element_text(
            color = nursery_teal
          ),
          plot.title = element_text(
            face = "bold",
            color = nursery_teal
          ),
          axis.title = element_text(
            color = nursery_teal
          ),
          legend.text = element_text(
            color = nursery_teal
          ),
          legend.title = element_text(
            color = nursery_teal
          )
        )
      
    })
    
    
    #5.9 DISPLAY INTERACTIVE TIME SERIES
    #Click chart points to identify original rows
    
    output$result_plot <- renderPlotly({
      
      ggplotly(
        time_plot(),
        tooltip = "text",
        source = "residue_plot"
      ) %>%
        event_register("plotly_click")
      
    })
    
    
    #5.10 INVESTIGATION REVIEW TABLE
    #Select a table row as an alternative to chart clicking
    
    output$review_table <- renderDT({
      
      data <- review_data()
      
      data <- data[data$Flag, ]
      
      datatable(
        
        data[
          ,
          c(
            "Date",
            "Value",
            "Row_Number",
            "Decision"
          )
        ],
        
        rownames = FALSE,
        
        selection = "single",
        
        options = list(
          pageLength = 10,
          scrollX = TRUE
        )
        
      )
      
    })
    
    
    #5.11 IDENTIFY SELECTED POINT
    #Support both chart click and table selection
    
    selected_row <- reactive({
      
      click <- event_data(
        "plotly_click",
        source = "residue_plot"
      )
      
      if (!is.null(click) &&
          !is.null(click$key)) {
        
        return(as.numeric(click$key[1]))
        
      }
      
      table_selection <- input$review_table_rows_selected
      
      if (length(table_selection) > 0) {
        
        data <- review_data()
        
        flagged <- data[data$Flag, ]
        
        if (nrow(flagged) >= table_selection[1]) {
          
          return(
            flagged$Row_Number[table_selection[1]]
          )
          
        }
        
      }
      
      NULL
      
    })
    
    
    #5.12 DISPLAY SELECTED ORIGINAL ROW

    
    output$selected_point <- renderDT({
      
      row <- selected_row()
      
      validate(
        need(!is.null(row), "Select a point or review-table row.")
      )
      
      data <- review_data()
      
      selected <- data[
        data$Row_Number == row,
        c(
          "Date",
          "Value",
          "Row_Number",
          "Flag",
          "Decision"
        ),
        drop = FALSE
      ]
      
      datatable(
        selected,
        rownames = FALSE,
        options = list(dom = "t")
      )
      
    })
    
    
    #5.13 SAVE KEEP / REMOVE DECISION
    
    observeEvent(input$save_decision, {
      
      row <- selected_row()
      
      if (is.null(row)) {
        showNotification(
          "Please select an investigation point first.",
          type = "error"
        )
        return()
      }
      
      current <- decisions()
      
      index <- match(
        row,
        current$Row_Number
      )
      
      if (!is.na(index)) {
        
        current$Decision[index] <- input$decision
        
        decisions(current)
        
        showNotification(
          paste(
            "Row", row,
            "saved as", input$decision
          ),
          type = "message"
        )
        
      } else {
        
        showNotification(
          "Selected row was not found.",
          type = "error"
        )
        
      }
      
    })
    
    
    #5.14 ANALYSIS DATA
    #Exclude results marked Remove
    
    analysis_data <- reactive({
      
      data <- review_data()
      
      data <- data[
        data$Decision == "Keep",
        ,
        drop = FALSE
      ]
      
      data
      
    })
    
    # Show Cards
    
    output$zero_count <- renderText({
      
      data <- analysis_data()
      
      sum(data$Value == 0)
      
    })
    
    
    output$positive_count <- renderText({
      
      data <- analysis_data()
      
      sum(data$Value > 0)
      
    })
    
    
    output$flag_count <- renderText({
      
      data <- review_data()
      
      sum(data$Flag)
      
    })
    
    #5.15 ZERO RESIDUE AND STATISTICAL SUMMARY
    
    output$summary <- renderPrint({
      
      before_data <- review_data()
      after_data <- analysis_data()
      
      cat("Product:", input$product, "\n")
      cat("--------------------------------\n")
      
      cat("BEFORE INVESTIGATION DECISION\n")
      cat("Total results:", nrow(before_data), "\n")
      cat("Investigation points:", sum(before_data$Flag), "\n")
      cat("Mean:", round(mean(before_data$Value), 3), "\n")
      cat("Median:", median(before_data$Value), "\n")
      cat("Maximum:", max(before_data$Value), "\n")
      
      cat("\nAFTER INVESTIGATION DECISION\n")
      cat("Kept results:", nrow(after_data), "\n")
      cat("Removed results:",
          sum(before_data$Decision == "Remove"), "\n")
      
      if (nrow(after_data) > 0) {
        
        cat("Mean:", round(mean(after_data$Value), 3), "\n")
        cat("Median:", median(after_data$Value), "\n")
        cat("Maximum:", max(after_data$Value), "\n")
        
      } else {
        
        cat("No results remaining after removal.\n")
        
      }
      
      cat("\nZERO RESIDUE COUNT:",
          sum(after_data$Value == 0), "\n")
      
      cat("POSITIVE RESIDUE COUNT:",
          sum(after_data$Value > 0), "\n")
      
    })
    
    
    #5.16 CREATE DENSITY PLOT
    #Only positive residue results
    
    density_plot <- reactive({
      
      data <- analysis_data()
      
      positive_data <- data[
        data$Value > 0,
        ,
        drop = FALSE
      ]
      
      validate(
        need(
          nrow(positive_data) >= 2,
          "At least two positive observations are required."
        ),
        
        need(
          length(unique(positive_data$Value)) > 1,
          "Positive observations must contain different values."
        )
      )
      
      ggplot(
        positive_data,
        aes(x = Value)
      ) +
        
        geom_density(
          fill = nursery_teal,
          color = nursery_teal,
          alpha = 0.35,
          linewidth = 1
        ) +
        
        labs(
          title = paste(
            "Positive Residue Density -",
            input$product
          ),
          x = "Residue (μg per part)",
          y = "Density"
        ) +
        
        theme_minimal(
          base_size = 13
        ) +
        
        theme(
          text = element_text(
            color = nursery_teal
          ),
          plot.title = element_text(
            face = "bold",
            color = nursery_teal
          )
        )
      
    })
    
    
    output$density_plot <- renderPlot({
      
      density_plot()
      
    })
    
    
    #5.17 ANDERSON-DARLING TEST
    #Use original statistician function
    
    output$ad_result <- renderPrint({
      
      data <- analysis_data()
      
      positive_data <- data$Value[
        data$Value > 0
      ]
      
      validate(
        need(
          length(positive_data) >= 8,
          "At least 8 positive observations are required for the AD test."
        ),
        
        need(
          length(unique(positive_data)) > 1,
          "Positive observations must contain different values."
        )
      )
      
      p_value <- ad_pvalue(positive_data)
      
      cat("Anderson-Darling Test\n")
      
      cat("-------------------------\n")
      
      cat(
        "Positive observations:",
        length(positive_data),
        "\n"
      )
      
      cat(
        "P-value:",
        format.pval(p_value, digits = 5),
        "\n"
      )
      
    })
    
    
    # 6. DOWNLOAD PLOTS AS PNG
    # New requirement: plots can be pasted into reports
    # ==========================================================
    
    
    #6.1 Download Time Series Plot
    
    output$download_time_plot <- downloadHandler(
      
      filename = function() {
        
        paste0(
          "Residue_Time_Series_",
          gsub("[^A-Za-z0-9_-]", "_", input$product),
          ".png"
        )
        
      },
      
      content = function(file) {
        
        ggsave(
          filename = file,
          plot = time_plot(),
          device = "png",
          width = 12,
          height = 7,
          units = "in",
          dpi = 300,
          bg = cream
        )
        
      }
      
    )
    
    
    #6.2 Download Density Plot
    
    output$download_density_plot <- downloadHandler(
      
      filename = function() {
        
        paste0(
          "Residue_Density_",
          gsub("[^A-Za-z0-9_-]", "_", input$product),
          ".png"
        )
        
      },
      
      content = function(file) {
        
        ggsave(
          filename = file,
          plot = density_plot(),
          device = "png",
          width = 12,
          height = 7,
          units = "in",
          dpi = 300,
          bg = cream
        )
        
      }
      
    )
    
  }
  
  
  # 7. RUN APP
  # ============================================================
  
  shinyApp(
    ui = ui,
    server = server
  )
  