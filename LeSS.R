library(shiny)
library(shinydashboard)

# Define the UI
ui <- dashboardPage(
  dashboardHeader(title = "LESS - Sample Size Calculator Online", dropdownMenu(type = "tasks", badgeStatus = "success",
    headerText = strong("Support"),
    messageItem(
      from = "Liên Hệ",
      message = "leanhngocump@gmail.com",
      href = "mailto:leanhngocump@gmail.com"
    ),
    messageItem(from = "Phân tích kết quả", message = "LePISTAT (Data Analysis Online)", 
                href = "https://ngocanhle.shinyapps.io/lepistat/")
  )),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Ước Lượng 1 Mẫu", icon = icon("clipboard"), tabName = "one_sample_estimation", 
               menuSubItem("Ước lượng một tỷ lệ", tabName = "proportion", icon = icon("percent")),
               menuSubItem("Ước lượng một trung bình", tabName = "mean", icon = icon("chart-line"))
      ),
      menuItem("Ước Lượng 2 Mẫu", icon = icon("clipboard-list"), tabName = "two_sample_estimation"),
      menuItem("So Sánh 2 Tỷ Lệ", icon = icon("chart-pie"), tabName = "compare_two_proportions"),
      menuItem("So Sánh 2 Trung Bình", icon = icon("chart-bar"), tabName = "compare_two_means")
    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        body, .content-wrapper, .right-side { font-family: 'Arial', sans-serif; }
        .box-title, .box-header { font-family: 'Arial', sans-serif; }
        .MathJax_Display { white-space: normal; overflow-wrap: break-word; max-width: 100%; }
        .result-table { width: 100%; table-layout: fixed; }
      "))
    ),
    tabItems(
      tabItem(tabName = "proportion", fluidRow(
        box(
          title = "Nhập Thông Số - Ước lượng một tỷ lệ", status = "primary", solidHeader = TRUE, width = 4,
          numericInput("alpha", "Sai lầm loại 1 (α)", value = 0.05, min = 0, max = 1, step = 0.01),
          textInput("p", "Tỉ lệ ước tính (p)", value = "0.3"),
          numericInput("d", "Sai số ước tính (d)", value = 0.05, min = 0, max = 1, step = 0.01),
          checkboxInput("enable_dropout", "Tính phần trăm dự trù mất mẫu", value = FALSE),
          conditionalPanel(condition = "input.enable_dropout == true",
                           numericInput("dropout_rate", "Phần trăm dự trù mất mẫu (%)", value = 10, min = 0, max = 100, step = 1)),
          actionButton("calculate", "Tính", class = "btn btn-success"),
          actionButton("reset", "Xóa", class = "btn btn-danger")
        ),
        box(
          title = "Kết Quả - Ước lượng một tỷ lệ", status = "primary", solidHeader = TRUE, width = 8,
          h4("Công Thức Tính Cỡ Mẫu"),
          withMathJax("$$ n \geq \frac{Z^2_{1-\alpha/2} \times (1 - p) \times p}{d^2} $$"),
          h4("Kết Quả Chi Tiết"),
          uiOutput("resultDisplay"),
          h4("Bảng Kết Quả"),
          tableOutput("resultTable")
        )
      )),
      tabItem(tabName = "compare_two_proportions", fluidRow(
        box(
          title = "Nhập Thông Số - So sánh 2 tỷ lệ", status = "primary", solidHeader = TRUE, width = 4,
          numericInput("alpha_compare", "Sai lầm loại 1 (α)", value = 0.05, min = 0, max = 1, step = 0.01),
          numericInput("p1", "Tỷ lệ nhóm 1 (p1)", value = 0.5, min = 0, max = 1, step = 0.01),
          numericInput("p2", "Tỷ lệ nhóm 2 (p2)", value = 0.4, min = 0, max = 1, step = 0.01),
          numericInput("d_compare", "Sai số ước tính (p1 - p2)", value = 0.1, min = 0, max = 1, step = 0.01),
          checkboxInput("enable_dropout_compare", "Tính phần trăm dự trù mất mẫu", value = FALSE),
          conditionalPanel(condition = "input.enable_dropout_compare == true",
                           numericInput("dropout_rate_compare", "Phần trăm dự trù mất mẫu (%)", value = 10, min = 0, max = 100, step = 1)),
          actionButton("calculate_compare", "Tính", class = "btn btn-success"),
          actionButton("reset_compare", "Xóa", class = "btn btn-danger")
        ),
        box(
          title = "Kết Quả - So sánh 2 tỷ lệ", status = "primary", solidHeader = TRUE, width = 8,
          h4("Công Thức Tính Cỡ Mẫu"),
          withMathJax("$$ n \geq \frac{Z^2_{1-\alpha/2} \times (p_1(1-p_1) + p_2(1-p_2))}{(p_1 - p_2)^2} $$"),
          h4("Kết Quả Chi Tiết"),
          uiOutput("resultDisplayCompare"),
          h4("Bảng Kết Quả"),
          tableOutput("resultTableCompare")
        )
      )),
      tabItem(tabName = "compare_two_means", fluidRow(
        box(
          title = "Nhập Thông Số - So sánh 2 trung bình", status = "primary", solidHeader = TRUE, width = 4,
          numericInput("alpha_compare_means", "Sai lầm loại 1 (α)", value = 0.05, min = 0, max = 1, step = 0.01),
          numericInput("mean1", "Trung bình nhóm 1 (mean1)", value = 50),
          numericInput("mean2", "Trung bình nhóm 2 (mean2)", value = 45),
          numericInput("sd1", "Độ lệch chuẩn nhóm 1 (sd1)", value = 10),
          numericInput("sd2", "Độ lệch chuẩn nhóm 2 (sd2)", value = 10),
          numericInput("d_compare_means", "Sai số ước tính (mean1 - mean2)", value = 5),
          checkboxInput("enable_dropout_compare_means", "Tính phần trăm dự trù mất mẫu", value = FALSE),
          conditionalPanel(condition = "input.enable_dropout_compare_means == true",
                           numericInput("dropout_rate_compare_means", "Phần trăm dự trù mất mẫu (%)", value = 10, min = 0, max = 100, step = 1)),
          actionButton("calculate_compare_means", "Tính", class = "btn btn-success"),
          actionButton("reset_compare_means", "Xóa", class = "btn btn-danger")
        ),
        box(
          title = "Kết Quả - So sánh 2 trung bình", status = "primary", solidHeader = TRUE, width = 8,
          h4("Công Thức Tính Cỡ Mẫu"),
          withMathJax("$$ n \geq \frac{(Z^2_{1-\alpha/2}) \times (s_1^2 + s_2^2)}{(\mu_1 - \mu_2)^2} $$"),
          h4("Kết Quả Chi Tiết"),
          uiOutput("resultDisplayCompareMeans"),
          h4("Bảng Kết Quả"),
          tableOutput("resultTableCompareMeans")
        )
      ))
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  observeEvent(input$calculate_compare, {
    if (is.na(input$alpha_compare) || is.na(input$p1) || is.na(input$p2) || is.na(input$d_compare)) {
      output$resultDisplayCompare <- renderUI({ HTML("Vui lòng điền đầy đủ thông tin.") })
      output$resultTableCompare <- renderTable(NULL)
      return()
    }
    z <- qnorm(1 - input$alpha_compare / 2)
    dropout_rate_proportion <- if (input$enable_dropout_compare) input$dropout_rate_compare / 100 else 0
    n <- (z^2 * (input$p1 * (1 - input$p1) + input$p2 * (1 - input$p2))) / (input$d_compare^2)
    n_minimum <- ceiling(n)
    n_adjusted <- if (input$enable_dropout_compare) ceiling(n_minimum / (1 - dropout_rate_proportion)) else n_minimum
    formula_with_values <- paste0(
      "$$ n \geq \frac{(", round(z, 2), ")^2 \times (", input$p1, "(1 - ", input$p1, ") + ", input$p2, "(1 - ", input$p2, "))}{(", input$d_compare, ")^2} = ", 
      n_minimum, if (input$enable_dropout_compare) paste0(", \quad n_{\\text{Hiệu chỉnh}} = ", n_adjusted) else ""
    )
    output$resultDisplayCompare <- renderUI({ withMathJax(formula_with_values) })
    output$resultTableCompare <- renderTable({
      data.frame(
        `Tỷ lệ nhóm 1 (p1)` = input$p1,
        `Tỷ lệ nhóm 2 (p2)` = input$p2,
        `Cỡ mẫu tối thiểu (n)` = n_minimum,
        if (input$enable_dropout_compare) `Cỡ mẫu hiệu chỉnh (n Hiệu chỉnh)` = n_adjusted else NULL,
        check.names = FALSE
      )
    }, rownames = FALSE, na = "")
  })

  observeEvent(input$calculate_compare_means, {
    if (is.na(input$alpha_compare_means) || is.na(input$mean1) || is.na(input$mean2) || is.na(input$sd1) || is.na(input$sd2) || is.na(input$d_compare_means)) {
      output$resultDisplayCompareMeans <- renderUI({ HTML("Vui lòng điền đầy đủ thông tin.") })
      output$resultTableCompareMeans <- renderTable(NULL)
      return()
    }
    z <- qnorm(1 - input$alpha_compare_means / 2)
    dropout_rate_proportion <- if (input$enable_dropout_compare_means) input$dropout_rate_compare_means / 100 else 0
    n <- (z^2 * (input$sd1^2 + input$sd2^2)) / (input$d_compare_means^2)
    n_minimum <- ceiling(n)
    n_adjusted <- if (input$enable_dropout_compare_means) ceiling(n_minimum / (1 - dropout_rate_proportion)) else n_minimum
    formula_with_values <- paste0(
      "$$ n \geq \frac{(", round(z, 2), ")^2 \times (", input$sd1^2, " + ", input$sd2^2, ")}{(", input$d_compare_means, ")^2} = ", 
      n_minimum, if (input$enable_dropout_compare_means) paste0(", \quad n_{\\text{Hiệu chỉnh}} = ", n_adjusted) else ""
    )
    output$resultDisplayCompareMeans <- renderUI({ withMathJax(formula_with_values) })
    output$resultTableCompareMeans <- renderTable({
      data.frame(
        `Trung bình nhóm 1 (mean1)` = input$mean1,
        `Trung bình nhóm 2 (mean2)` = input$mean2,
        `Độ lệch chuẩn nhóm 1 (sd1)` = input$sd1,
        `Độ lệch chuẩn nhóm 2 (sd2)` = input$sd2,
        `Cỡ mẫu tối thiểu (n)` = n_minimum,
        if (input$enable_dropout_compare_means) `Cỡ mẫu hiệu chỉnh (n Hiệu chỉnh)` = n_adjusted else NULL,
        check.names = FALSE
      )
    }, rownames = FALSE, na = "")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
