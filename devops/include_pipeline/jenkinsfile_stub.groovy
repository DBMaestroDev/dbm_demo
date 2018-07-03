//
@Library('devops-global-include') _

println "#----------- Remote Pipeline Execution ------------#"

//library 'devops-global-include'
// Add a properties for Platform and Skip_Packaging more
properties([
        parameters([
                choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes')
        ])
])

def pipe = new org.dbmaestro.PipelineInclude()
pipe.execute()
println "Finished"