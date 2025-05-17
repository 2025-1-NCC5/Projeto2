
    import React from 'react';
    import { Link } from 'react-router-dom';
    import { motion } from 'framer-motion';
    import { Button } from '@/components/ui/button';
    import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
    import { Target, ListChecks, Users, ArrowRight } from 'lucide-react';

    const HomePage = () => {
      const cardVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
      };

      return (
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.5 }}
          className="flex flex-col items-center justify-center text-center py-12"
        >
          <motion.h1 
            initial={{ y: -50, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ type: 'spring', stiffness: 120, delay: 0.2 }}
            className="text-5xl md:text-6xl font-extrabold mb-6 tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-pink-400 via-purple-400 to-indigo-400"
          >
            Bem-vindo à Avaliação 360°
          </motion.h1>
          <motion.p 
            initial={{ y: -30, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ type: 'spring', stiffness: 120, delay: 0.4 }}
            className="text-xl text-gray-200 mb-12 max-w-2xl"
          >
            Uma ferramenta poderosa para feedback construtivo e desenvolvimento profissional contínuo.
            Comece a avaliar ou veja os resultados das avaliações.
          </motion.p>

          <div className="grid md:grid-cols-2 gap-8 w-full max-w-4xl">
            <motion.div variants={cardVariants} initial="hidden" animate="visible" custom={0}>
              <Card className="hover:shadow-xl transition-shadow duration-300 bg-opacity-20 border-purple-400">
                <CardHeader>
                  <div className="flex items-center justify-center mb-4">
                    <Target className="h-12 w-12 text-pink-400" />
                  </div>
                  <CardTitle className="text-3xl font-semibold text-white">Fazer Avaliação</CardTitle>
                  <CardDescription className="text-gray-300">
                    Contribua com seu feedback para o crescimento da equipe.
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <Button asChild size="lg" className="w-full bg-gradient-to-r from-pink-500 to-purple-600 hover:from-pink-600 hover:to-purple-700 text-white font-semibold">
                    <Link to="/avaliar" className="flex items-center justify-center">
                      Iniciar Avaliação <ArrowRight className="ml-2 h-5 w-5" />
                    </Link>
                  </Button>
                </CardContent>
              </Card>
            </motion.div>

            <motion.div variants={cardVariants} initial="hidden" animate="visible" custom={1}>
              <Card className="hover:shadow-xl transition-shadow duration-300 bg-opacity-20 border-indigo-400">
                <CardHeader>
                  <div className="flex items-center justify-center mb-4">
                    <ListChecks className="h-12 w-12 text-indigo-400" />
                  </div>
                  <CardTitle className="text-3xl font-semibold text-white">Ver Resultados</CardTitle>
                  <CardDescription className="text-gray-300">
                    Acompanhe o progresso e as médias das avaliações.
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <Button asChild size="lg" className="w-full bg-gradient-to-r from-indigo-500 to-purple-600 hover:from-indigo-600 hover:to-purple-700 text-white font-semibold">
                    <Link to="/resultados" className="flex items-center justify-center">
                      Visualizar Resultados <ArrowRight className="ml-2 h-5 w-5" />
                    </Link>
                  </Button>
                </CardContent>
              </Card>
            </motion.div>
          </div>
          
          <motion.div 
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.8, duration: 0.5 }}
            className="mt-16 p-8 rounded-xl glassmorphism max-w-3xl"
          >
            <div className="flex items-center justify-center mb-4">
              <Users className="h-10 w-10 text-purple-300" />
            </div>
            <h2 className="text-2xl font-semibold text-white mb-3">Por que Avaliação 360°?</h2>
            <p className="text-gray-300 leading-relaxed">
              A avaliação 360 graus coleta feedback de múltiplas fontes – colegas, subordinados, supervisores e até autoavaliação. Isso proporciona uma visão completa do desempenho, identifica pontos fortes e áreas para desenvolvimento, promovendo uma cultura de transparência e melhoria contínua.
            </p>
          </motion.div>
          
          <div className="mt-12">
            <img  alt="Team collaborating in a modern office" class="w-full max-w-2xl rounded-lg shadow-2xl" src="https://images.unsplash.com/photo-1651009188116-bb5f80eaf6aa" />
          </div>

        </motion.div>
      );
    };

    export default HomePage;
  