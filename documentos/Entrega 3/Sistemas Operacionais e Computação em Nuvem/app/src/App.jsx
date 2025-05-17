
    import React from 'react';
    import { BrowserRouter as Router, Route, Routes, Link, Outlet } from 'react-router-dom';
    import { Home, Users, Target, PlusCircle, ListChecks } from 'lucide-react';
    import { motion } from 'framer-motion';
    import HomePage from '@/pages/HomePage';
    import EvaluationPage from '@/pages/EvaluationPage';
    import ResultsPage from '@/pages/ResultsPage';
    import { Toaster } from '@/components/ui/toaster';
    import { Button } from '@/components/ui/button';

    const Layout = () => {
      return (
        <div className="flex flex-col min-h-screen">
          <header className="p-4 bg-black bg-opacity-50 text-white shadow-lg">
            <nav className="container mx-auto flex justify-between items-center">
              <Link to="/" className="text-2xl font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-pink-500 via-purple-500 to-indigo-500">
                Avaliação 360°
              </Link>
              <div className="space-x-4">
                <Button variant="ghost" asChild>
                  <Link to="/" className="flex items-center space-x-2 hover:text-pink-400 transition-colors">
                    <Home size={20} /> <span>Início</span>
                  </Link>
                </Button>
                <Button variant="ghost" asChild>
                  <Link to="/avaliar" className="flex items-center space-x-2 hover:text-pink-400 transition-colors">
                    <Target size={20} /> <span>Fazer Avaliação</span>
                  </Link>
                </Button>
                <Button variant="ghost" asChild>
                  <Link to="/resultados" className="flex items-center space-x-2 hover:text-pink-400 transition-colors">
                    <ListChecks size={20} /> <span>Resultados</span>
                  </Link>
                </Button>
              </div>
            </nav>
          </header>
          <main className="flex-grow container mx-auto p-4 md:p-8">
            <Outlet />
          </main>
          <footer className="p-4 bg-black bg-opacity-30 text-center text-sm text-gray-300">
            <p>© {new Date().getFullYear()} Avaliação 360°. Todos os direitos reservados.</p>
            <p>Desenvolvido com <span className="text-pink-400">♥</span> por Hostinger Horizons</p>
          </footer>
          <Toaster />
        </div>
      );
    };

    function App() {
      return (
        <Router>
          <Routes>
            <Route path="/" element={<Layout />}>
              <Route index element={<HomePage />} />
              <Route path="avaliar" element={<EvaluationPage />} />
              <Route path="resultados" element={<ResultsPage />} />
            </Route>
          </Routes>
        </Router>
      );
    }

    export default App;
  