
  library(GDINA)
sidebar <- shinydashboard::dashboardSidebar(
  shinydashboard::sidebarMenu(
    shinydashboard::menuItem("Input", tabName = "input", icon = icon("file-text")),
    shinydashboard::menuItem("Estimation Settings", icon = icon("rocket"), tabName = "est"),
    shinydashboard::sidebarMenuOutput("summary"),
    shinydashboard::sidebarMenuOutput("fit"),
    shinydashboard::sidebarMenuOutput("par"),
    shinydashboard::sidebarMenuOutput("qv"),
    shinydashboard::sidebarMenuOutput("msec"),
    shinydashboard::sidebarMenuOutput("menuplot")
  )
)

body <- shinydashboard::dashboardBody(
    shinydashboard::tabItems(
    # input files
    shinydashboard::tabItem(tabName = "input",
                            shiny::fluidRow(
                              shinydashboard::box(
                                title = NULL, width = 12,
                                shiny::p(shiny::strong("About this graphical user interface")),

                                shiny::p('This GUI application is developed with',
                                         shiny::a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"), 'and',
                                         shiny::a("shinydashboard", href="http://rstudio.github.io/shinydashboard/", target="_blank"),
                                         'and distributed as part of',
                                         ' the',shiny::a("GDINA", href="https://CRAN.R-project.org/package=GDINA", target="_blank"),"R package by",
                                         shiny::a("Wenchao Ma", href="https://wenchaoma.people.ua.edu/", target="_blank"), 'and',
                                         shiny::a("Jimmy de la Torre.", href="https://web.edu.hku.hk/staff/academic/j.delatorre", target="_blank")),

                                shiny::p("For examples, tutorials, and citation information, among others, please visit",
                                         shiny::a("this website.", href="https://wenchao-ma.github.io/GDINA/", target="_blank")),

                                shiny::br(),

                                shiny::p("The GUI application, as well as the GDINA R package, is free, and you can redistribute it and or modify
           it under the terms of the GNU General Public License as published by
           the Free Software Foundation version 3 of the License."),

                                shiny::p("The program is distributed in the hope that it will be useful,
           but WITHOUT ANY WARRANTY; without even the implied warranty of
           MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
           GNU General Public License for more details."),

                                shiny::br(),
                                shiny::p("Should you have any comments or suggestions, please email Wenchao Ma at wenchao.ma@ua.edu.")
                              )),
            shiny::fluidRow(
              shinydashboard::box(
              title = "Upload response matrix", width = 6, solidHeader = TRUE, status = "primary",
            shiny::fileInput('file1', NULL,
                      accept = c('text/csv','text/comma-separated-values',
                                 'text/tab-separated-values', 'text/plain',
                                 '.csv', '.tsv')
            ),
            shiny::checkboxInput('header', 'Header', FALSE),
            shiny::radioButtons('sep', 'Separator',
                         c(Tab='\t', Comma=',',Semicolon=';',
                           Space=''),
                         '\t',inline = TRUE)
            ),
            shinydashboard::box(
              title = "Upload Q-matrix", width = 6, solidHeader = TRUE, status = "primary",
              shiny::fileInput('file2', NULL,
                        accept = c('text/csv','text/comma-separated-values',
                                   'text/tab-separated-values','text/plain',
                                   '.csv','.tsv')
              ),
              shiny::checkboxInput('header2', 'Header', FALSE),
              shiny::radioButtons('sep2', 'Separator',
                                               c(Tab='\t', Comma=',',Semicolon=';',
                                                 Space=''),
                                               '\t',inline = TRUE)
              )),
            shiny::fluidRow(
              shinydashboard::box(title = "First 6 observations of the responses", width = 12, solidHeader = TRUE, collapsible = TRUE, status = "primary",
                                  shiny::tableOutput('contents1')
              )
            ),
            shiny::fluidRow(
              shinydashboard::box(title = "First 6 items of the Q-matrix", width = 12, solidHeader = TRUE, collapsible = TRUE, status = "primary",
                                  shiny::tableOutput('contents2')
              )
            )
    ),

    shinydashboard::tabItem(tabName = "est",
                            shiny::fluidRow(
                              shinydashboard::box(height = "350px",
                                title = "Measurement models", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
                                shiny::selectInput("type", label = "Select a single CDM for all items",
                                                   choices = list("GDINA [Generalized deterministic inputs, noisy and gate] model" = "GDINA",
                                                                  "logit GDINA model [loglinear CDM]" = "logitGDINA",
                                                                  "log GDINA model" = "logGDINA",
                                                                  "DINA [Deterministic inputs, noisy and gate] model" = "DINA",
                                                                  "DINO [Deterministic inputs, noisy or gate] model" = "DINO",
                                                                  "ACDM [Additive cognitive diagnosis model]" = "ACDM",
                                                                  "R-RUM [Reduced reparameterized unified model]" = "RRUM",
                                                                  "LLM/C-RUM [Linear logistic model/Compensatory RUM]" = "LLM",
                                                                  "To be specified..."="UM"), selected = "GDINA"),
                                shiny::textInput('mv', 'Or choose "To be specified..." above and enter a vector of models (comma delimited without quotation marks)', 'GDINA,DINA,LLM,...'),
                                shiny::br(),
                                shiny::checkboxInput("mono", label = "Monotonic Constraints?", value = FALSE),
                                shiny::checkboxInput("seq", label = "Sequential models for polytomous responses?", value = FALSE)
                              ),
                              shinydashboard::box(height = "350px",
                                title = "Other settings", width = 6, collapsible = TRUE, solidHeader = TRUE,status = "primary",
                                shiny::p(shiny::strong("Joint attribute distribution:")),
                                shiny::radioButtons("attdis", NULL,
                                                    choices = list("Saturated model"=0,
                                                                   "Higher-order Rasch model"=1,
                                                                   "Higher-order 1PL model"=2,
                                                                   "Higher-order 2PL model"=3,
                                                                   "Uniform distribution"=4)),
                                shiny::hr(),
                                shiny::p(shiny::strong("Model diagnostics:")),
                                shiny::checkboxInput("qvalcheck", label = "Q-matrix validation?", value = FALSE),
                                shiny::checkboxInput("modelsel", label = "Item-level model selection (only applicable for G-DINA model)?", value = FALSE)
                              )

                            ),
                            shiny::fluidRow(
                              shiny::br(),
                              column(12, align="center", offset = 0,
                                     actionButton("goButton",label = "CLICK TO ESTIMATE!"),
                                     tags$style(type='text/css', "#button { vertical-align- middle; height- 100px; width- 100%; font-size- 50px;}")
                                     ))),
shinydashboard::tabItem(tabName = "summary",
                        shiny::h2("Model estimation summary"),
                        hr(),
                        shiny::fluidRow(
                          shinydashboard::box(
                            title = "Estimation summary", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
                            shiny::verbatimTextOutput('iter.info')
                          ),
                          shinydashboard::box(
                            title = "Classification summary", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
                            shiny::verbatimTextOutput('iter.info2')
                          )
                        )
),
shinydashboard::tabItem(tabName = "fit",
        shiny::fluidRow(
          shinydashboard::box(
            title = "Relative test fit", width = 4, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('info')
          ),
          shinydashboard::box(
            title = "Absolute test fit", width = 8, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('itfit')
          )),
        shiny::fluidRow(shinydashboard::box(
          title = "Item-fit plot specifications", width = 4, solidHeader = TRUE, collapsible = TRUE, status = "primary",
          shiny::radioButtons("heatmap.type", "Plot type:",
                       choices = c("log odds ratio", "transformed correlation")),
          shiny::checkboxInput("heatmap.adjust", label = "Bonferroni adjusted?", value = TRUE),
          shiny::downloadButton('downloadHeatPlot', 'Download Plot as PDF file')
        ),
          shinydashboard::box(
            title = "Heatmap plots", width = 8, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("heatplot")
          ))),
shinydashboard::tabItem(tabName = "par",
        shiny::h2("Parameter estimation"),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Item parameter estimation specifications", width = 4, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::selectInput("ips", label = "Item parameters",
                        choices = list("Success probabilities of reduced latent classes" = "catprob",
                                       "Guessing and slip parameters" = "gs",
                                       "Delta parameters" = "delta",
                                       "Success probabilities of all latent classes"="LCprob"), selected = "catprob"),
            shiny::checkboxInput("ipse", label = "Estimate S.E.?", value = TRUE)
            ),
          shinydashboard::box(
            title = "Item parameter estimates", width = 8, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('ip')
          )),
        shiny::fluidRow(
          shinydashboard::box(
          title = "Person parameter estimation specifications", width = 4, solidHeader = TRUE, collapsible = TRUE, status = "primary",
          shiny::selectInput("pp", label = "Person parameter estimation method:",
                      choices = list("EAP" = "EAP", "MAP" = "MAP","MLE" = "MLE","Probabilities of mastering each attribute"="mp"), selected = "EAP"),
          shiny::downloadButton('downloadpp', 'Download'),
          shiny::radioButtons("ppfiletype", "File type:",
                       choices = c("csv", "tsv"))
        ),
        shinydashboard::box(
            title = "Person parameter estimates of first 10 observations", width = 8, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('pparm')
          )),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Estimated proportions of latent classes specifications", width = 4, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::selectInput("plc", label = "Sorted by:",
                               choices = list("default" = "default", "decreasing" = "decreasing","increasing" = "increasing"), selected = "default"),
            shiny::downloadButton('downloadplc', 'Download'),
            shiny::radioButtons("plcfiletype", "File type:",
                                choices = c("csv", "tsv"))
          ),
          shinydashboard::box(
            title = "Estimated proportions of first 10 latent classes", width = 8, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('plc.output')
          ))
),
shinydashboard::tabItem(tabName = "Qval",
        shiny::h2("Q-matrix validation"),
        shiny::fluidRow(
            shinydashboard::box(
              title = "Q-matrix validation specifications", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
              shiny::radioButtons("qv.method", "Q-validation method:",
                                  choices = list("PVAF"="PVAF", "Stepwise Wald test"="Wald")),
              shiny::sliderInput("PVAFcutoff", label = h3("PVAF cutoff"), min = 0,
                          max = 1, value = 0.95)
            ),
            shinydashboard::box(
              title = "Suggested Q-matrix", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
              shiny::verbatimTextOutput('sugQ')
            )),
        shiny::fluidRow(shinydashboard::box(
          title = "Mesa plot specifications", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
          shiny::numericInput("item.mesaplot",label = "Item #",
                       value = 1, min = 1),
          shiny::radioButtons("mesatype", "Plot type:",
                       choices = c("best", "all")),
          shiny::checkboxInput("datalabel", label = "Data labels?", value = FALSE),
          shiny::downloadButton('downloadMesaplot', 'Download Plot as PDF file')
        ),
        shinydashboard::box(
          title = "Mesa plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
          shiny::plotOutput("mesaplot")
        ))
),
shinydashboard::tabItem(tabName = "ms",
        shiny::h2("Item-level model selection outputs"),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Summary", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::verbatimTextOutput('ss')
          ),
          shinydashboard::box(
            title = "Wald statistics and p-values", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::h3("Wald statistics"),
            shiny::verbatimTextOutput('ws'),
            shiny::h3("P-values"),
            shiny::verbatimTextOutput('pv')
          ))
),
shinydashboard::tabItem(tabName = "plot",
        shiny::h2("Plots for individual statistics"),
        shiny::br(),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Specifications for individuals' mastery plots", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::textInput('personid', 'Enter a vector of individuals (comma delimited)', "1,2,5"),
            shiny::checkboxInput("HPlot", label = "Horizontal?", value = FALSE),
            shiny::downloadButton('downloadmpplot', 'Download Plot as PDF file')
          ),
          shinydashboard::box(
            title = "Plot of probability of mastery for individuals", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("Mplot")
          )),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Specifications for individual posterior probability plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::numericInput("ippid",label = "Specify an individual:", value = 1, min = 1),
            shiny::selectInput("ippplc", label = "Sorted by:",
                               choices = list("default" = "default", "decreasing" = "decreasing","increasing" = "increasing"), selected = "default"),
            shiny::numericInput('inlc', 'Enter the maximum number of latent classes:', value=10,min = 1),
            shiny::checkboxInput("ippAdir", label = "Horizontal?", value = FALSE),
            shiny::downloadButton('downloadiPPplot', 'Download Plot as PDF file')
          ),
          shinydashboard::box(
            title = "Individual posterior probability plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("iPostProbplot")
          )),
        shiny::h2("Plots for group statistics"),
        shiny::br(),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Specifications for proportions of latent classes plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::selectInput("ppplc", label = "Sorted by:",
                               choices = list("default" = "default", "decreasing" = "decreasing","increasing" = "increasing"), selected = "default"),
            shiny::numericInput('nlc', 'Enter the maximum number of latent classes:', value=10,min = 1),
            shiny::checkboxInput("ppAdir", label = "Horizontal?", value = FALSE),
            shiny::downloadButton('downloadPPplot', 'Download Plot as PDF file')
          ),
          shinydashboard::box(
            title = "Plot of proportions of latent classes", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("PostProbplot")
          )),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Specifications for attribute prevalence plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::selectInput("palette", label = "RColorBrewer palette",
                               choices = list("Set2" = "Set2", "Greys" = "Greys","Paired" = "Paired","Accent"="Accent"), selected = "default"),
            shiny::checkboxInput("Adir", label = "Horizontal?", value = FALSE),
            shiny::downloadButton('downloadAPplot', 'Download Plot as PDF file')
          ),
          shinydashboard::box(
            title = "Plot of attribute prevalence", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("APplot")
          )),
        shiny::h2("Plots for item statistics"),
        shiny::br(),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Specifications for item response function plots", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::numericInput("item.plot",label = "Specify the item for IRF plot:", value = 1,min = 1),
            shiny::checkboxInput("IRFplotse", label = "Errorbars?", value = FALSE),
            shiny::downloadButton('downloadIRFplot', 'Download Plot as PDF file')
          ),
          shinydashboard::box(
            title = "Item response function plot", width = 6, solidHeader = TRUE, collapsible = TRUE, status = "primary",
            shiny::plotOutput("plot")
          ))
)
)
)

shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "GDINA GUI"),
  sidebar,
  body
)
