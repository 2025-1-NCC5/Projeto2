
    import React, { useState, useEffect } from 'react';
    import { motion } from 'framer-motion';
    import { Button } from '@/components/ui/button';
    import { Input } from '@/components/ui/input';
    import { Label } from '@/components/ui/label';
    import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
    import { Slider } from '@/components/ui/slider';
    import { PlusCircle, Trash2, Send, User } from 'lucide-react';
    import { useToast } from '@/components/ui/use-toast';
    import { v4 as uuidv4 } from 'uuid';

    const EvaluationPage = () => {
      const { toast } = useToast();
      const [evaluatorName, setEvaluatorName] = useState('');
      const [teamMembers, setTeamMembers] = useState([
        { id: uuidv4(), name: '', communication: 5, leadership: 5, proactivity: 5 },
      ]);

      const handleAddMember = () => {
        setTeamMembers([
          ...teamMembers,
          { id: uuidv4(), name: '', communication: 5, leadership: 5, proactivity: 5 },
        ]);
      };

      const handleRemoveMember = (id) => {
        setTeamMembers(teamMembers.filter((member) => member.id !== id));
      };

      const handleMemberChange = (id, field, value) => {
        setTeamMembers(
          teamMembers.map((member) =>
            member.id === id ? { ...member, [field]: value } : member
          )
        );
      };

      const handleSubmit = (e) => {
        e.preventDefault();
        if (!evaluatorName.trim()) {
          toast({
            title: 'Erro na Avaliação',
            description: 'Por favor, insira o nome do avaliador.',
            variant: 'destructive',
          });
          return;
        }

        const incompleteMember = teamMembers.find(member => !member.name.trim());
        if (incompleteMember) {
          toast({
            title: 'Erro na Avaliação',
            description: 'Por favor, insira o nome de todos os integrantes avaliados.',
            variant: 'destructive',
          });
          return;
        }
        
        if (teamMembers.length === 0) {
          toast({
            title: 'Erro na Avaliação',
            description: 'Adicione pelo menos um integrante para avaliar.',
            variant: 'destructive',
          });
          return;
        }

        const newEvaluation = {
          id: uuidv4(),
          evaluatorName,
          evaluations: teamMembers,
          date: new Date().toISOString(),
        };

        try {
          const existingEvaluations = JSON.parse(localStorage.getItem('evaluations360')) || [];
          localStorage.setItem('evaluations360', JSON.stringify([...existingEvaluations, newEvaluation]));
          
          toast({
            title: 'Avaliação Enviada!',
            description: 'Sua avaliação foi registrada com sucesso.',
          });

          setEvaluatorName('');
          setTeamMembers([{ id: uuidv4(), name: '', communication: 5, leadership: 5, proactivity: 5 }]);
        } catch (error) {
          toast({
            title: 'Erro ao Salvar',
            description: 'Não foi possível salvar a avaliação. Tente novamente.',
            variant: 'destructive',
          });
        }
      };
      
      const pageVariants = {
        initial: { opacity: 0, y: 20 },
        in: { opacity: 1, y: 0 },
        out: { opacity: 0, y: -20 },
      };

      const itemVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: (i) => ({
          opacity: 1,
          y: 0,
          transition: {
            delay: i * 0.1,
            type: 'spring',
            stiffness: 100,
          },
        }),
      };

      return (
        <motion.div
          initial="initial"
          animate="in"
          exit="out"
          variants={pageVariants}
          transition={{ duration: 0.5 }}
          className="max-w-4xl mx-auto py-8"
        >
          <Card className="bg-opacity-25 border-purple-500 shadow-2xl">
            <CardHeader className="text-center">
              <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.2, type: 'spring' }}>
                <User className="h-16 w-16 mx-auto text-pink-400 mb-4" />
              </motion.div>
              <CardTitle className="text-4xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-pink-500 via-purple-500 to-indigo-500">
                Formulário de Avaliação
              </CardTitle>
              <CardDescription className="text-gray-300 text-lg">
                Forneça seu feedback sobre os membros da equipe.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-8">
                <motion.div variants={itemVariants} initial="hidden" animate="visible" custom={0} className="space-y-2">
                  <Label htmlFor="evaluatorName" className="text-xl font-semibold text-gray-100">Seu Nome (Avaliador)</Label>
                  <Input
                    id="evaluatorName"
                    type="text"
                    placeholder="Digite seu nome completo"
                    value={evaluatorName}
                    onChange={(e) => setEvaluatorName(e.target.value)}
                    className="bg-white/10 border-purple-400 text-white placeholder-gray-400 focus:ring-pink-500 focus:border-pink-500"
                  />
                </motion.div>

                {teamMembers.map((member, index) => (
                  <motion.div
                    key={member.id}
                    variants={itemVariants}
                    initial="hidden"
                    animate="visible"
                    custom={index + 1}
                    className="p-6 rounded-lg border border-purple-400 bg-white/5 space-y-6 relative"
                  >
                    <div className="flex justify-between items-center">
                       <h3 className="text-2xl font-semibold text-pink-400">Avaliação do Integrante #{index + 1}</h3>
                      {teamMembers.length > 1 && (
                        <Button
                          type="button"
                          variant="destructive"
                          size="sm"
                          onClick={() => handleRemoveMember(member.id)}
                          className="absolute top-4 right-4 bg-red-500 hover:bg-red-600"
                        >
                          <Trash2 size={18} className="mr-1" /> Remover
                        </Button>
                      )}
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor={`memberName-${member.id}`} className="text-lg text-gray-200">Nome do Integrante</Label>
                      <Input
                        id={`memberName-${member.id}`}
                        type="text"
                        placeholder="Nome do integrante da equipe"
                        value={member.name}
                        onChange={(e) => handleMemberChange(member.id, 'name', e.target.value)}
                        className="bg-white/10 border-purple-400 text-white placeholder-gray-400 focus:ring-pink-500 focus:border-pink-500"
                      />
                    </div>

                    {[
                      { label: 'Comunicação', field: 'communication' },
                      { label: 'Liderança', field: 'leadership' },
                      { label: 'Proatividade', field: 'proactivity' },
                    ].map((skill) => (
                      <div key={skill.field} className="space-y-3">
                        <div className="flex justify-between items-center">
                          <Label htmlFor={`${skill.field}-${member.id}`} className="text-lg text-gray-200">{skill.label}</Label>
                          <span className="text-pink-400 font-semibold text-lg">{member[skill.field]}</span>
                        </div>
                        <Slider
                          id={`${skill.field}-${member.id}`}
                          min={0}
                          max={10}
                          step={1}
                          value={[member[skill.field]]}
                          onValueChange={(value) => handleMemberChange(member.id, skill.field, value[0])}
                          className="[&>span:first-child>span]:bg-pink-500 [&>span:last-child]:bg-purple-500 [&>span:last-child]:border-purple-300"
                        />
                      </div>
                    ))}
                  </motion.div>
                ))}

                <motion.div variants={itemVariants} initial="hidden" animate="visible" custom={teamMembers.length + 1} className="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
                  <Button
                    type="button"
                    onClick={handleAddMember}
                    variant="outline"
                    className="w-full sm:w-auto border-pink-500 text-pink-500 hover:bg-pink-500 hover:text-white transition-colors duration-300"
                  >
                    <PlusCircle size={20} className="mr-2" /> Adicionar Integrante
                  </Button>
                  <Button type="submit" size="lg" className="w-full sm:w-auto bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600 text-white font-semibold transition-all duration-300 transform hover:scale-105">
                    <Send size={20} className="mr-2" /> Enviar Avaliação
                  </Button>
                </motion.div>
              </form>
            </CardContent>
          </Card>
        </motion.div>
      );
    };

    export default EvaluationPage;
  