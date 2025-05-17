
    import React, { useState, useEffect } from 'react';
    import { motion } from 'framer-motion';
    import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
    import { BarChart3, Users, MessageSquare, Zap, Award, Star, User } from 'lucide-react';
    import { useToast } from '@/components/ui/use-toast';

    const ResultsPage = () => {
      const [aggregatedResults, setAggregatedResults] = useState({});
      const [isLoading, setIsLoading] = useState(true);
      const { toast } = useToast();

      useEffect(() => {
        try {
          const storedEvaluations = JSON.parse(localStorage.getItem('evaluations360')) || [];
          const results = {};

          storedEvaluations.forEach(evaluationSet => {
            evaluationSet.evaluations.forEach(memberEval => {
              const memberName = memberEval.name.trim();
              if (!memberName) return;

              if (!results[memberName]) {
                results[memberName] = {
                  communication: [],
                  leadership: [],
                  proactivity: [],
                  count: 0,
                };
              }
              results[memberName].communication.push(memberEval.communication);
              results[memberName].leadership.push(memberEval.leadership);
              results[memberName].proactivity.push(memberEval.proactivity);
              results[memberName].count += 1;
            });
          });
          
          const finalResults = {};
          for (const name in results) {
            finalResults[name] = {
              communication: results[name].communication.reduce((a, b) => a + b, 0) / results[name].count,
              leadership: results[name].leadership.reduce((a, b) => a + b, 0) / results[name].count,
              proactivity: results[name].proactivity.reduce((a, b) => a + b, 0) / results[name].count,
              count: results[name].count,
            };
          }
          setAggregatedResults(finalResults);
        } catch (error) {
          toast({
            title: 'Erro ao Carregar Resultados',
            description: 'Não foi possível carregar os dados das avaliações.',
            variant: 'destructive',
          });
        } finally {
          setIsLoading(false);
        }
      }, [toast]);

      const pageVariants = {
        initial: { opacity: 0, y: 20 },
        in: { opacity: 1, y: 0 },
        out: { opacity: 0, y: -20 },
      };

      const cardVariants = {
        hidden: { opacity: 0, scale: 0.9 },
        visible: (i) => ({
          opacity: 1,
          scale: 1,
          transition: {
            delay: i * 0.15,
            type: 'spring',
            stiffness: 100,
          },
        }),
      };
      
      const skillIcons = {
        communication: <MessageSquare className="h-6 w-6 text-blue-400" />,
        leadership: <Award className="h-6 w-6 text-green-400" />,
        proactivity: <Zap className="h-6 w-6 text-yellow-400" />,
      };

      if (isLoading) {
        return (
          <div className="flex justify-center items-center h-64">
            <motion.div
              animate={{ rotate: 360 }}
              transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
              className="w-16 h-16 border-t-4 border-b-4 border-pink-500 rounded-full"
            ></motion.div>
            <p className="ml-4 text-xl text-white">Carregando resultados...</p>
          </div>
        );
      }
      
      const sortedResults = Object.entries(aggregatedResults).sort(([, a], [, b]) => {
        const avgA = (a.communication + a.leadership + a.proactivity) / 3;
        const avgB = (b.communication + b.leadership + b.proactivity) / 3;
        return avgB - avgA; 
      });


      return (
        <motion.div
          initial="initial"
          animate="in"
          exit="out"
          variants={pageVariants}
          transition={{ duration: 0.5 }}
          className="max-w-5xl mx-auto py-8"
        >
          <Card className="bg-opacity-25 border-indigo-500 shadow-2xl mb-10">
            <CardHeader className="text-center">
              <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.2, type: 'spring' }}>
                <BarChart3 className="h-16 w-16 mx-auto text-indigo-400 mb-4" />
              </motion.div>
              <CardTitle className="text-4xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
                Resultados das Avaliações
              </CardTitle>
              <CardDescription className="text-gray-300 text-lg">
                Médias consolidadas das avaliações recebidas.
              </CardDescription>
            </CardHeader>
          </Card>

          {Object.keys(aggregatedResults).length === 0 ? (
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="text-center py-10"
            >
              <Users className="h-24 w-24 mx-auto text-gray-400 mb-4" />
              <p className="text-2xl text-gray-300">Nenhuma avaliação encontrada ainda.</p>
              <p className="text-gray-400">Comece a avaliar para ver os resultados aqui!</p>
            </motion.div>
          ) : (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {sortedResults.map(([name, scores], index) => (
                <motion.div key={name} custom={index} variants={cardVariants} initial="hidden" animate="visible">
                  <Card className="bg-white/10 border-purple-400 hover:shadow-purple-500/30 hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                    <CardHeader>
                      <CardTitle className="text-2xl font-semibold text-pink-400 flex items-center">
                        <User className="mr-3 h-7 w-7" /> {name}
                      </CardTitle>
                      <CardDescription className="text-gray-400">
                        {scores.count} {scores.count === 1 ? 'avaliação recebida' : 'avaliações recebidas'}
                      </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      {['communication', 'leadership', 'proactivity'].map((skill) => (
                        <div key={skill} className="flex items-center justify-between p-3 bg-white/5 rounded-md">
                          <div className="flex items-center">
                            {skillIcons[skill]}
                            <span className="ml-3 text-lg capitalize text-gray-200">{skill.charAt(0).toUpperCase() + skill.slice(1)}</span>
                          </div>
                          <div className="flex items-center">
                            <span className="text-xl font-bold text-purple-300">{scores[skill].toFixed(1)}</span>
                            <Star className="ml-1 h-5 w-5 text-yellow-400" />
                          </div>
                        </div>
                      ))}
                       <div className="mt-4 pt-3 border-t border-purple-500/50">
                        <div className="flex items-center justify-between">
                          <span className="text-lg font-semibold text-gray-100">Média Geral</span>
                          <span className="text-2xl font-bold text-pink-400">
                            {((scores.communication + scores.leadership + scores.proactivity) / 3).toFixed(1)}
                          </span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          )}
        </motion.div>
      );
    };

    export default ResultsPage;
  